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

package auth

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"strings"

	"github.com/coreos/go-oidc/v3/oidc"
)

type Config struct {
	Domain    string
	LogAccess bool
}

type Claims struct {
	Email      string `json:"email"`
	CommonName string `json:"common_name"`
}

const certificatesPath = "%scdn-cgi/access/certs"

var (
	config       *Config
	remoteKeySet *oidc.RemoteKeySet
)

type RouteHandler = func(w http.ResponseWriter, req *http.Request, aud string)

func Route(conf *Config) RouteHandler {
	if !strings.HasSuffix(conf.Domain, "/") {
		conf.Domain = conf.Domain + "/"
	}
	config = conf
	remoteKeySet = oidc.NewRemoteKeySet(context.TODO(), fmt.Sprintf(certificatesPath, conf.Domain))

	return func(w http.ResponseWriter, req *http.Request, aud string) {
		token := req.Header.Get("Cf-Access-Jwt-Assertion")
		if len(token) < 1 {
			w.WriteHeader(http.StatusUnauthorized)
			return
		}

		claims, err := verifyToken(aud, token, req.Context())
		if err != nil {
			w.WriteHeader(http.StatusUnauthorized)
			return
		}

		var id string
		if len(claims.Email) > 0 {
			id = claims.Email
		} else if len(claims.CommonName) > 0 {
			id = claims.CommonName
		}

		if config.LogAccess {
			log.Printf("Access granted for %s to %s\n", id, aud)
		}

		w.Header().Set("X-Auth-User", id)
		w.WriteHeader(http.StatusOK)
	}
}

func verifyToken(audience string, token string, context context.Context) (*Claims, error) {
	oidConfig := &oidc.Config{ClientID: audience}
	verifier := oidc.NewVerifier(config.Domain, remoteKeySet, oidConfig)

	id, err := verifier.Verify(context, token)
	if err != nil {
		return nil, err
	}

	claims := &Claims{}
	err = id.Claims(claims)
	if err != nil {
		return nil, err
	}

	return claims, nil
}
