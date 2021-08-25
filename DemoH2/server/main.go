package main

import (
	"crypto/tls"
	"crypto/x509"
	"encoding/pem"
	"fmt"
	"io/ioutil"
	"net/http"
	"strconv"
)

type handler struct{}

func (h handler) ServeHTTP(r http.ResponseWriter, q *http.Request) {
	r.Write([]byte("Https response OK\n"))
}

func main() {

	go TLSServer(11555)
	go mTLSServer(11666)
	select {}
}

func TLSServer(port int) {
	server := http.Server{
		Addr:    ":" + strconv.FormatInt(int64(port), 10),
		Handler: handler{},
	}

	fmt.Printf("Start TLS server at %v\n", port)
	if err := server.ListenAndServeTLS("server.crt", "serverPrivKey.pem"); err != nil {
		fmt.Println(err)
	}
}

func mTLSServer(port int) {
	pool := x509.NewCertPool()
	certBytes, err := ioutil.ReadFile("caRootCert.crt")
	if err != nil {
		fmt.Println(err)
		return
	}
	certBlock, _ := pem.Decode(certBytes)
	cert, err := x509.ParseCertificate(certBlock.Bytes)
	if err != nil {
		fmt.Println(err)
		return
	}
	pool.AddCert(cert)
	config := tls.Config{
		// 指定client的验证模式，至少要发送一个被信任的证书
		ClientAuth: tls.RequireAndVerifyClientCert,
		ClientCAs:  pool,
	}

	server := http.Server{
		Addr:      ":" + strconv.FormatInt(int64(port), 10),
		TLSConfig: &config,
		Handler:   handler{},
	}

	fmt.Printf("Start mTLS server at %v\n", port)
	if err := server.ListenAndServeTLS("server.crt", "serverPrivKey.pem"); err != nil {
		fmt.Println(err)
	}
}
