这是生成的一个证书的例子，做一些讲解

从结构来看，这个证书包含连个部分, Data, 和 Signature Algorithm

Data部分包含这个证书的基本信息(Body)

包括
* Version 版本
* Serial Number 序列号
* SignatureAlgorithm 签名算法
* Issuer 签名者
* Validity 有效日期
* Subject 证书的持有者信息，这里的CN(Common Name)，一般要对应证书的域名
* Subject Public Key Info 证书的公钥

而 Signature，则是一段由Issuer 签发者的私钥所加密的一段信息

被加密的信息为，上述data通过 SignatureAlgorithm 签名算法，所得到的哈希值

作为一个接收者，当得到一个数字证书时，如何验证它是否可信呢？

1. 检测有效期
2. 检测Common Name
3. 通过证书链（系统内、浏览器置的证书等）得到 Issuer 签发者的公钥 PK1
4. 使用签名算法计算Data部分的摘要值H1
5. 通过PK1，对证书中 Signature 部分进行解密,得到H2
6. 对比H1 和 H2的值，如果相等，则证书可信

所以说，排除有效期、CommonName等别的因素，系统、浏览器内置的证书，实际上是给我们提供了一些公钥 Public Key，我们可以通过这些预留的公钥来验证由它们签发的证书的有效性

因为它们在签发证书时，使用了与公钥对应的私钥对签发证书的Signature 签名部分进行了加密

而我们可以使用这些预留证书中与之对应的公钥来进行解密，从而达到验证的目的


```
Certificate:
    Data:
        Version: 1 (0x0)
        Serial Number:
            78:a8:3d:d8:19:94:50:3b:88:66:de:6d:66:81:e9:5d:d9:40:b8:cb
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C = CN, O = test, OU = test, CN = caTest.com
        Validity
            Not Before: Aug 25 08:38:24 2021 GMT
            Not After : Aug 23 08:38:24 2031 GMT
        Subject: C = CN, O = test, OU = test, CN = caTest.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:f5:80:fa:61:8e:a2:50:df:0c:00:30:29:90:a8:
                    35:ac:85:52:a5:7c:1b:7d:9b:39:27:d7:e5:84:fa:
                    05:45:3e:71:a2:77:44:4c:fd:31:87:2a:f4:f4:36:
                    bd:3d:6c:cd:b5:d6:47:ee:e1:80:d7:79:95:10:f7:
                    7b:b3:fe:73:8f:24:57:df:53:e9:79:63:a0:aa:82:
                    28:b4:8f:0a:c0:27:17:4e:ba:1d:f5:c8:d2:8e:4a:
                    0e:e2:7a:63:ac:c8:2d:7e:2e:86:07:66:2c:2e:cd:
                    2d:6b:eb:ff:5c:62:b8:cc:b4:f3:3c:9b:73:c4:7d:
                    86:e5:8f:03:74:1b:d3:a2:04:0f:4d:e8:a0:ab:c6:
                    81:ad:b5:18:56:47:a6:42:01:be:f4:13:0d:f1:59:
                    bd:81:3c:f6:fb:64:8e:69:cc:8d:27:3b:cd:ad:7c:
                    79:5b:93:c0:60:2a:26:e1:40:17:cb:b6:36:50:c5:
                    31:ad:83:ab:30:0f:a1:0f:96:05:71:4b:63:2b:a8:
                    78:14:ae:07:f1:6e:b7:3f:a2:3a:ff:d5:71:09:f2:
                    6c:09:4c:3c:80:1b:a1:50:18:5e:29:74:2a:c4:b9:
                    fa:19:b1:cd:b4:5b:2c:42:f4:c7:15:15:10:ed:d3:
                    ed:20:66:56:a5:38:20:94:7e:29:44:3f:6c:a3:0d:
                    2e:0d
                Exponent: 65537 (0x10001)
    Signature Algorithm: sha256WithRSAEncryption
         da:af:67:11:20:04:57:99:0f:0b:65:82:8a:af:5c:d1:5a:79:
         10:e1:54:01:8d:7e:fd:a6:f5:85:22:29:94:b0:5a:39:08:cc:
         20:21:c6:61:2a:af:aa:75:e1:c7:d9:40:0e:c5:89:b0:e2:e4:
         85:f1:d7:08:2e:91:a0:2a:43:17:82:51:72:87:08:cc:8f:61:
         ab:fb:2b:38:59:95:cf:4a:6d:5b:da:c6:5c:28:9b:9d:5c:00:
         af:4e:c7:27:15:b2:6a:c4:d5:af:b7:e6:d7:76:9d:d7:8a:cf:
         f7:6d:1a:ec:b8:99:2a:19:8c:12:a3:36:4d:ac:09:0f:6f:56:
         3e:d3:9b:cf:07:4e:c0:f9:50:fa:bd:5f:72:03:5c:92:14:c7:
         f9:49:98:92:f6:fb:3c:e0:3e:f8:32:b5:54:a0:09:56:20:a3:
         e7:5f:70:2e:b2:a9:43:f1:ee:e2:b0:51:46:2c:0d:87:0c:3a:
         97:3d:27:0f:13:bc:fb:8c:d3:df:44:d1:38:b5:7a:39:0c:b8:
         d2:ac:ba:01:7d:74:43:f4:b4:93:8a:b5:fc:7e:d1:3a:ba:d2:
         10:31:e6:fb:91:4c:f7:5f:20:10:79:df:55:08:fc:66:52:a8:
         0c:7d:4a:98:66:89:cc:bb:3b:2f:ae:1c:7c:21:74:bc:d3:5a:
         af:31:fa:d2
```