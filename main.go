package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"

	"github.com/newrelic/go-agent/v3/newrelic"
)

func InitLogger(
	infoHandle io.Writer,
	warningHandle io.Writer,
	errorHandle io.Writer,
) {
	Info = log.New(infoHandle,
		"INFO: ",
		log.Ldate|log.Ltime|log.Lshortfile)

	Warning = log.New(warningHandle,
		"WARNING: ",
		log.Ldate|log.Ltime|log.Lshortfile)

	Error = log.New(errorHandle,
		"ERROR: ",
		log.Ldate|log.Ltime|log.Lshortfile)
}

var (
	Info    *log.Logger
	Warning *log.Logger
	Error   *log.Logger
)

func main() {

	InitLogger(os.Stdout, os.Stdout, os.Stderr)

	app, err := newrelic.NewApplication(
		newrelic.ConfigAppName("go-hello-world-api"),
		newrelic.ConfigLicense(os.Getenv("NEW_RELIC_LICENSE")),
	)
	if err != nil {
		log.Println("New Relic application failed to start. Continuing with app startup anyway.")
	}

	http.HandleFunc(newrelic.WrapHandleFunc(app, "/", Handler))
	log.Println("Starting server on port 8080")

	log.Fatal(http.ListenAndServe(":8080", nil))
}

func Handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, World!")
	log.Println("Successfully returned 200 for \"Hello World\"")
}
