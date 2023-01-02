/*
 * Kani - Traefik forward auth server for Cloudflare Access
 * Copyright (c) 2022 Joshua Sing.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package app

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"syscall"

	"github.com/HyperaDev/kani/internal/auth"
)

type Config struct {
	Port      int
	Domain    string
	LogAccess bool
}

func Start(config *Config) {
	log.Println("Starting...")

	http.HandleFunc("/", handler(auth.Route(&auth.Config{
		Domain:    config.Domain,
		LogAccess: config.LogAccess,
	})))

	exit := make(chan os.Signal, 1)
	signal.Notify(exit, syscall.SIGINT, syscall.SIGTERM, os.Interrupt, os.Kill)

	go func() {
		log.Fatalln(http.ListenAndServe(fmt.Sprintf(":%d", config.Port), http.DefaultServeMux))
	}()

	log.Printf("Successfully started, listening on :%d\n", config.Port)
	<-exit
	log.Println("Goodbye")
}

func handler(handle auth.RouteHandler) func(w http.ResponseWriter, req *http.Request) {
	return func(w http.ResponseWriter, req *http.Request) {
		aud := strings.TrimPrefix(req.URL.Path, "/")
		if len(aud) > 0 {
			// Handle /:aud
			handle(w, req, aud)
			return
		}

		w.WriteHeader(http.StatusOK)
	}
}
