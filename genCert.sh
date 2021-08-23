
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


# generate a private key
openssl genrsa -out caPrivKey.pem 2048

# generate a certificate request
openssl req -new -key caPrivKey.pem -out certReq.csr -subj "/C=CN/ST=shanghai/L=shanghai/O=test/OU=test/CN=caTest.com"

# general, if you want to generate a useful certifcate, you should send the certificate request to a real CA
# and pay some money, they will give you a signed certificate
# but we generate a self-signed certificate as RootCert (This way usually done by real CA, they use the RootCert to sign other certificates)
openssl x509 -req -days 3650 -in certReq.csr -signkey caPrivKey.pem -out caRootCert.crt

# verify the contents of cert
openssl x509 -in caRootCert.crt -noout -text -out caCertDescription.txt

cat caCertDescription.txt


# use the self-signed certificate as rootCert to sign other certificate

# generate a server private key
openssl genrsa -out serverPrivKey.pem 2048

openssl req -new -key serverPrivKey.pem -out server.csr -subj "/C=CN/ST=shanghai/L=shanghai/O=test/OU=test/CN=localhost"

# the command openssl ca will use some configuration, so we choose openssl x509 to sign other certificates
# openssl ca -days 365 -in server.csr -out server.crt -cert rootCert.crt -keyfile caPrivKey.pem
openssl x509 -req -in server.csr -CA caRootCert.crt -CAkey caPrivKey.pem -out server.crt -CAcreateserial

openssl x509 -in server.crt -noout -text


# verify whether the server.crt is signed by rootCert.crt

echo "verify whether the server.crt is signed by rootCert.crt"
openssl verify -CAfile caRootCert.crt server.crt