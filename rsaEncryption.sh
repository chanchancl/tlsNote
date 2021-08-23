
#
# receiver --------public key--------------> sender
#
#
#                  public key
#                       |
# file.in ---------------------------------> file.en ( sender )
#
#                  private key
#                       |
# file.en ---------------------------------> file.de.in ( receiver )
#
# then sender can send any data to receiver
# but this process will cost lots of cpu resource
# in tls, they only use this to verify each other and exchange a key that will used by symmetric encryption
#

if [ $1 ] && [ $1 = "clean" ]; then
    rm -rf testRsaEncrypt
    exit
fi

mkdir testRsaEncrypt
cd testRsaEncrypt

#
# generate a RSA private key (from man openssl genrsa, we can known this is a private key)
openssl genrsa -out privKey.pem 2048
# generate the public key from private key
openssl rsa -in privKey.pem -pubout -out pubKey.pem

# prepare input file
echo "test text will be encrypted" > test.txt

# use pubkey to encrypt the file, you will delivery the pub key to the sender
# who wants to send decrypted data to receiver
openssl rsautl -encrypt -in test.txt -inkey pubKey.pem -pubin -out test.en

# use private key to decrypt the file and get plain text
openssl rsautl -decrypt -in test.en -inkey privKey.pem -out test.de.txt
