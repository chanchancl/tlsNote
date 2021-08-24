
#
# User : private key + subj -> CSR(certificate signing request)
# CA   : CSR + caPrivateKey + caPrivateCert -> signed user cert
#
# 如果一个 CA 是根证书，那么它可以被用来验证别的证书是否是由它签发的
#
testDir="CertTest"

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


# 生成私钥
openssl genrsa -out caPrivKey.pem 2048

# 生成证书签名请求，并附上用户信息
openssl req -new -key caPrivKey.pem -out certReq.csr -subj "/C=CN/O=test/OU=test/CN=caTest.com"

# 通常在这一步，如果你想生成一个可以在生产环境中使用的证书，你需要把证书签名请求发送给一些知名的 证书签名机构（CA）
# 并且付一些钱，它们会给你一个由他们签名的证书，因为他们的根证书，往往是被大家所信任的（例如系统、浏览器等）
# 但这里我们生成一个自签名根证书 (CA在生成根证书时，会使用这种方法)
openssl x509 -req -days 3650 -in certReq.csr -signkey caPrivKey.pem -out caRootCert.crt

# 检查证书的信息
openssl x509 -in caRootCert.crt -noout -text -out caCertDescription.txt

cat caCertDescription.txt


# 使用刚才的自签名根证书，来为其他人签名

# 生成私钥，证书签名请求
openssl genrsa -out serverPrivKey.pem 2048
openssl req -new -key serverPrivKey.pem -out server.csr -subj "/C=CN/O=test/OU=test/CN=localhost"

# 命令 openssl ca 需要额外使用一些配置, 所以我选择更加简单的命令 openssl x509 来对其他证书进行签名
# openssl ca -days 365 -in server.csr -out server.crt -cert rootCert.crt -keyfile caPrivKey.pem
openssl x509 -req -days 365 -in server.csr -CA caRootCert.crt -CAkey caPrivKey.pem -out server.crt -CAcreateserial

openssl x509 -in server.crt -noout -text


# 生成 client 证书
openssl genrsa -out clientPrivKey.pem 2048
openssl req -new -key clientPrivKey.pem -out client.csr -subj "/C=CN/O=test/OU=test/CN=localhost2"
openssl x509 -req -days 30 -in client.csr -CA caRootCert.crt -CAkey caPrivKey.pem -out client.crt -CAcreateserial
openssl x509 -in client.crt -noout -text

# caRootCert.crt -> server.crt 
#                -> client.crt


echo "verify whether the server.crt is signed by rootCert.crt"
openssl verify -CAfile caRootCert.crt server.crt
echo "verify whether the client.crt is signed by server.crt"
openssl verify -CAfile caRootCert.crt client.crt

