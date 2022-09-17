# Kani
<strong>A Traefik ForwardAuth server for Cloudflare Access</strong><br /><br />
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/joshuasing/kani?sort=semver&color=cd7f84&style=for-the-badge)](https://hub.docker.com/r/joshuasing/kani)
[![Docker Pulls](https://img.shields.io/docker/pulls/joshuasing/kani?color=cd7f84&style=for-the-badge)](https://hub.docker.com/r/joshuasing/kani)
[![License](https://img.shields.io/badge/License-MIT-%23cd7f84?style=for-the-badge)](LICENSE)<br/>
![Code size](https://img.shields.io/github/languages/code-size/HyperaDev/kani?color=cd7f84&style=for-the-badge)
![Code lines](https://img.shields.io/tokei/lines/github/HyperaDev/kani?label=Lines%20of%20code&style=for-the-badge&color=cd7f84)

## What is Kani?
[Kani (カニ)](https://ja.wikipedia.org/wiki/カニ) ([Pronunciation](http://ipa-reader.xyz/?text=kan%CA%B2i)) means Crab in Japanese.
I'm not entirely sure what I decided to use this name, but here we are.
Kani is designed to be a [Traefik](https://github.com/traefik/traefik) ForwardAuth server for validating [Cloudflare Access](https://www.cloudflare.com/products/zero-trust/access/) requests.

When a request is proxied through Cloudflare Access, a signed JWT token will be sent to the backend (Traefik in this case) as an HTTP header.
Since the JWT token is signed, we can get the public keys from Cloudflare Access to validate that it was indeed issued by Cloudflare Access.


## Why use Kani?
It is recommended to use Kani when you are using Cloudflare Access in-front of a service that is behind Traefik.  
Kani allows Traefik to validate that the request actually went through Cloudflare Access and that the user was granted access, therefore preventing people from bypassing Cloudflare Access.

## Getting started
**See examples in [examples/](examples)**.

### License
Kani is licensed under the terms of the MIT License.  
See [LICENSE](LICENSE) for the full license.
