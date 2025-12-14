package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strings"
	"time"
)

type SimpleTimeService struct {
	Timestamp string
	Ip        string
}

func getClientIpAddr(req *http.Request) string {
	clientIp := req.Header.Get("X-Forwarded-For")
	if clientIp != "" {
		firstIp := strings.Split(clientIp, ",")[0]
		return firstIp
	}
	return req.RemoteAddr
}

func main() {
	server := &http.Server{
		Addr:    ":8080",
		Handler: nil,
	}

	http.HandleFunc("/", helperFunction)
	http.HandleFunc("/health", checkServerHealth)

	err := server.ListenAndServe()
	if err != nil {
		fmt.Println("Error starting server:", err)
	}
}

func helperFunction(w http.ResponseWriter, r *http.Request) {
	currentTime := time.Now()
	formattedTime := currentTime.Format("2006-01-02 15:04:05")
	clientIp := getClientIpAddr(r)

	w.Header().Set("Content-Type", "application/json")

	simpleTimeService := SimpleTimeService{
		Timestamp: formattedTime,
		Ip:        clientIp,
	}

	w.WriteHeader(http.StatusOK)

	json.NewEncoder(w).Encode(simpleTimeService)
}

func checkServerHealth(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("I am working fine..!"))
}
