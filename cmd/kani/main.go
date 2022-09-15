/*
 * Kani - Cloudflare Access verification for Traefik
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

package main

import (
	"log"
	"strconv"

	"github.com/HyperaDev/kani/internal/app"
	"github.com/HyperaDev/kani/internal/utils"
)

var config *app.Config

func init() {
	port, err := strconv.Atoi(utils.Getenv("PORT", "80"))
	if err != nil {
		log.Fatalln("environment variable must be an integer: PORT")
	}

	domain := utils.Getenv("CLOUDFLARE_DOMAIN", utils.Getenv("CF_DOMAIN", ""))
	if len(domain) == 0 {
		log.Fatalln("environment variable must be set: CLOUDFLARE_DOMAIN")
	}

	logAccess := utils.Getenv("LOG_ACCESS", "") == "true"

	config = &app.Config{
		Port:      port,
		Domain:    domain,
		LogAccess: logAccess,
	}
}

func main() {
	app.Start(config)
}
