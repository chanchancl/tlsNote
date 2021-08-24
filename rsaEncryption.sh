
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
# 之后 sender 就可以向 receiver 发送加密消息了
# 但是这个过程非常消耗计算资源
# 在TLS中，这个过程通常用来验证彼此双方的身份，和交换用于后续对称加密的密钥
#

testDir="RsaEncryptTest"

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

#
# 生成一个RSA 私钥 (从 man openssl genrsa 可以看出，我们生成的是一个私钥)
openssl genrsa -out privKey.pem 2048
# 通过私钥计算出公钥
openssl rsa -in privKey.pem -pubout -out pubKey.pem

# 准备明文
echo "test text will be encrypted" > test.txt

# 发送者使用公钥加密明文, 你通常需要把公钥发送给想要给你发送密文的人
openssl rsautl -encrypt -in test.txt -inkey pubKey.pem -pubin -out test.en

# 使用私钥对密文进行解密，并得到明文
openssl rsautl -decrypt -in test.en -inkey privKey.pem -out test.de.txt
