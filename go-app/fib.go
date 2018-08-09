package main

import (
    "fmt"
    "net/http"
	"log"
	"strconv"
)

func fib(n int) uint {
    if n == 0 {
        return 0
    } else if n == 1 {
		return 1
	} else {
		return fib(n-1) + fib(n-2)
	}
}

func fibServer(w http.ResponseWriter, r *http.Request) {

	r.ParseForm()
	n, err := strconv.Atoi(r.FormValue("n"))
    if err != nil {
		fmt.Println("Error")
		return
    }

    fmt.Println("n", r.FormValue("n"))
	
    fmt.Fprintf(w, fmt.Sprintf("%v",fib(n)))
}

func main() {
    http.HandleFunc("/", fibServer) // set router
    err := http.ListenAndServe(":9090", nil) // set listen port
    if err != nil {
        log.Fatal("ListenAndServe: ", err)
    }
}