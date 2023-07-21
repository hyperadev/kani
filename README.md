# Kani

<strong>A fast Traefik forward-auth server for validating Cloudflare Access requests</strong><br /><br />
[![License](https://img.shields.io/badge/License-MIT-%23cd7f84?style=for-the-badge)](LICENSE)
![Code quality](https://img.shields.io/codefactor/grade/github/HyperaDev/kani/main?style=for-the-badge&color=cd7f84)<br />
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/joshuasing/kani?sort=semver&color=cd7f84&style=for-the-badge&label=Latest%20Release)](https://hub.docker.com/r/joshuasing/kani)
[![Docker Pulls](https://img.shields.io/docker/pulls/joshuasing/kani?color=cd7f84&style=for-the-badge)](https://hub.docker.com/r/joshuasing/kani)

<!-- TOC -->
* [Kani](#kani)
  * [What is Kani?](#what-is-kani)
  * [Why use Kani?](#why-use-kani)
  * [Getting started](#getting-started)
  * [Contributing](#contributing)
    * [Contact](#contact)
    * [License](#license)
  * [Acknowledgements](#acknowledgements)
    * [Supporters](#supporters)
<!-- TOC -->

## What is Kani?

[Kani (カニ)](https://ja.wikipedia.org/wiki/カニ) ([Pronunciation](http://ipa-reader.xyz/?text=kan%CA%B2i)) means Crab in
Japanese.
I'm not entirely sure what I decided to use this name, but here we are.
Kani is designed to be a [Traefik](https://github.com/traefik/traefik) ForwardAuth server for
validating [Cloudflare Access](https://www.cloudflare.com/products/zero-trust/access/) requests.

When a request is proxied through Cloudflare Access, a signed JWT token will be sent to the backend (Traefik in this
case) as an HTTP header.
Since the JWT token is signed, we can get the public keys from Cloudflare Access to validate that it was indeed issued
by Cloudflare Access.

## Why use Kani?

We recommend using Kani when using Cloudflare Access to protect websites.
Kani allows Traefik to validate that requests actually went through Cloudflare Access, preventing users from accessing
the page without going through Cloudflare Access.

## Getting started

**See examples in [examples/](examples)**.

## Contributing

If you would like to contribute to this project, please see [CONTRIBUTING.md](CONTRIBUTING.md).

### Contact

If you want to contact the Kani Project maintainers, please use one of the following methods:

- [Discord server](https://discord.hypera.dev/) (Ask questions here please - best response time)
- [Email `oss@hypera.dev`](mailto:oss@hypera.dev)
- [Email `support@hypera.dev`](mailto:support@hypera.dev)
- [Email `security@hypera.dev`](mailto:security@hypera.dev) (security-related matters only)

### License

Kani is distributed under the terms of the MIT License.  
For further details, please refer to the [LICENSE](LICENSE) file.

## Acknowledgements

We are extremely grateful to the
[amazing individuals who have contributed to this project](https://github.com/HyperaDev/kani/graphs/contributors),
as well as those who have supported us by providing valuable feedback and donations.

We would also like to thank all the individuals and companies who have supported us in sustaining
this project. We are grateful for their valuable contributions that have enabled us to continue to
improve Kani.

Please note that the individuals and companies listed under the "Supporters" section are
independent of this project, and their inclusion should not be interpreted as an endorsement or
affiliation.

### Supporters

We don't currently have any supporters for this project :(  
If you would like to sponsor this project, please [contact us](#contact)!

