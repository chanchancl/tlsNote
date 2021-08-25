# tlsNote

学习TLS过程中的一些笔记和脚本，用来帮助理解

## rsaEncryption.sh

使用RSA来进行加密和揭秘数据

parameter:
* clean : clean generated files

## genCert.sh

首先生成一个自签名证书，并用它再签名两个子证书 server.crt 和 client.crt

并将其复制到 DemoH2 需要用到的位置

parameter:
* clean : clean generated files

## DemoH2

使用 golang 写了一个同时启动 TLS 和 mTLS 的http server

使用 curl 命令作为client 连接上述http server

## caCert.sh

使用 openssl ca 命令来模拟CA进行证书签发，并生成一个中间CA

再使用中间CA生成用户证书 user.crt，可以使用证书链 cert-chain.crt 来验证user.crt是否可信

## certExample.md

简要解释一下一个数字证书的组成部分,和如何验证证书