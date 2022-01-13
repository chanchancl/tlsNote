package main

import (
	"crypto/tls"
	"crypto/x509"
	"encoding/pem"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
)

func main() {
	curlTLS()
	curlmTLS()
}

type wWriter struct{}

func (w *wWriter) Write(b []byte) (int, error) {
	fmt.Println(string(b), len(b))
	return len(b), nil
}

func curlTLS() {
	conf := tls.Config{
		InsecureSkipVerify: true,
		KeyLogWriter:       &wWriter{},
	}

	client := http.Client{Transport: &http.Transport{
		TLSClientConfig: &conf,
	}}

	rsp, err := client.Get("https://localhost:11555")
	if err != nil {
		log.Println(err)
		return
	}
	defer rsp.Body.Close()
	bts, _ := io.ReadAll(rsp.Body)
	log.Println(string(bts))
}

func curlmTLS() {
	cert, err := tls.LoadX509KeyPair("client.crt", "clientPrivKey.pem")
	if err != nil {
		log.Println(err)
		return
	}

	certBytes, err := ioutil.ReadFile("caRootCert.crt")
	if err != nil {
		panic("Unable to read caRootCert.crt")
	}
	certBlock, _ := pem.Decode(certBytes)
	rootCert, _ := x509.ParseCertificate(certBlock.Bytes)

	rootCertPool := x509.NewCertPool()
	rootCertPool.AddCert(rootCert)

	conf := tls.Config{
		RootCAs:            rootCertPool,
		Certificates:       []tls.Certificate{cert},
		InsecureSkipVerify: true,
		KeyLogWriter:       &wWriter{},
	}

	client := http.Client{Transport: &http.Transport{
		TLSClientConfig: &conf,
	}}

	rsp, err := client.Get("https://localhost:11666")
	if err != nil {
		log.Println(err)
		return
	}
	defer rsp.Body.Close()
	bts, _ := io.ReadAll(rsp.Body)
	log.Println(string(bts))
}
