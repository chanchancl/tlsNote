
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
openssl genrsa -out privKey.key 2048
# generate the public key from private key
openssl rsa -in privKey.key -pubout -out pubKey.key

# prepare input file
echo "test text will be encrypted" > test.txt

# use pubkey to encrypt the file, you can also use certificate key to encrypt
# but general you will only delivery the pub key to other people who will use it
openssl rsautl -encrypt -in test.txt -inkey pubKey.key -pubin -out test.en

# use certificate key(priv part) to decrypt the file and get plain text
openssl rsautl -decrypt -in test.en -inkey privKey.key -out test.de.txt
