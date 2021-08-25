
#
# 根 CA -> 中间CA
#
# 由中间CA来给请求签名的用户，签发证书，一定程度上可以保护一下 根CA
#
# 根CA可以放在完全隔绝的环境里
#
# 如果一个 CA 是根证书，那么它可以被用来验证别的证书是否是由它签发的
#
testDir="demoCATest"

if [ $1 ] && [ $1 = "clean" ]; then
    echo $testDir
    rm -rf $testDir
    exit
fi
if [ ! -d $testDir ]; then
    mkdir $testDir
else
    rm -rf $testDir/*
fi
cd $testDir

mkdir {certs,newcerts,private}
touch index.txt
echo "01" > serial
cp ../openssl.cnf .

# 现在，我们在 demoCaTest 目录
# ./certs/
# ./newcerts/
# ./private/
# ./index.txt
# ./serial


# 生成私钥
openssl genrsa -out ./private/cakey.pem 2048
# 生成证书签名请求
openssl req -new -key ./private/cakey.pem -out rootCA.csr -subj "/C=CN/O=test/OU=test/CN=Ccl Test Root Certificate"
# 自签名，使用 openssl.cnf 作为配置
openssl ca -batch -config ./openssl.cnf -days 36500 -selfsign -in rootCA.csr -extensions v3_ca

cp newcerts/01.pem cacert.pem

mkdir intermediate
cd intermediate
mkdir {certs,newcerts,private}
touch index.txt
echo "01" > serial
cp ../openssl.cnf .

# 生成中间CA证书
openssl genrsa -out ./private/cakey.pem 2048
openssl req -new -key ./private/cakey.pem -out ./intermediateCA.csr -subj "/C=CN/O=test/OU=test/CN=Ccl Test Intermediate Certificate"
# 将中间CA的证书签名请求交给根CA
cp intermediateCA.csr ..
cd ..

# 根CA对中间CA进行签名
openssl ca -batch -config ./openssl.cnf -days 3650 -in ./intermediateCA.csr -extensions v3_ca -out intermediateCA.crt

# 将签发的中间证书给 中间CA
cp intermediateCA.crt intermediate/cacert.pem
cd intermediate

# 生成证书链，可以将这个证书链发送给别人，如果别人信任这个证书链，那么任何由 中间CA 签发的证书，都是可以被信任的
cat ../cacert.pem cacert.pem > cert-chain.crt

openssl genrsa -out ./user.pem 2048
openssl req -new -key ./user.pem -out ./user.csr -subj "/C=CN/O=test/OU=test/CN=Ccl User Certificate"
openssl ca -batch -config ./openssl.cnf -days 365 -in ./user.csr -extensions v3_ca -out user.crt

echo "检测 user.crt 是否可以被信任"
openssl verify -CAfile cert-chain.crt user.crt
