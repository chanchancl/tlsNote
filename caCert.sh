
#
# User : private key + subj -> CSR(certificate signing request)
# CA   : CSR + caPrivateKey + caPrivateCert -> signed user cert
#
# 如果一个 CA 是根证书，那么它可以被用来验证别的证书是否是由它签发的
#
# testDir="CaCertTest"

# if [ $1 ] && [ $1 = "clean" ]; then
#     echo $testDir
#     rm -rf $testDir
#     exit
# fi
# if [ ! -d $testDir ]; then
#     mkdir $testDir
# else
#     rm -rf $testDir/*
# fi
# cd $testDir

rm -rf ./demoCATest
mkdir ./demoCATest
cd ./demoCATest

mkdir {certs,newcerts,private}
touch index.txt
echo "01" > serial

# 现在，我们在 demoCaTest 目录
# ./certs/
# ./newcerts/
# ./private/
# ./index.txt
# ./serial


# 生成私钥
openssl genrsa -out ./private/cakey.pem 2048
# 生成证书签名请求
openssl req -new -key ./private/cakey.pem -out rootCA.csr -subj "/C=CN/O=test/OU=test/CN=caTest.com"
# 自签名，使用 openssl.cnf 作为配置
openssl ca -config ../openssl.cnf -selfsign -in rootCA.csr -extensions v3_ca

cp newcerts/01.pem cacert.pem

# 检查证书的信息
# openssl x509 -in caRootCert.crt -noout -text