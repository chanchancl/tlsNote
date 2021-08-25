
使用这个Demo之前，请先运行 genCert.sh

# server

使用 golang 写的server

同时开启了2个https server，分别为

11555: TLS

11666: mTLS

# client

使用 curl 命令来作为 client，访问 server