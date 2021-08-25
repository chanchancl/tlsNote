
# client 使用 curl 命令将就一下
echo 'curl --cacert caRootCert.crt https://localhost:11555'
curl --cacert caRootCert.crt https://localhost:11555
echo 'curl --cacert caRootCert.crt --cert client.crt --key clientPrivKey.pem https://localhost:11666'
curl --cacert caRootCert.crt --cert client.crt --key clientPrivKey.pem https://localhost:11666