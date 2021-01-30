# Wrapper for Haven Core

This project wraps [Haven](https://havenprotocol.org) for EmbassyOS. Haven is an ecosystem of untraceable assets that enables users to convert between volatile assets and stable currencies directly within their vault, with complete privacy.

## Contributing

We welcome contributions from all!

For non-technical contributors, please use the `Issues` section above to communicate your desired edits or additions.

For technical contributors, please fork this repository, make your changes according to the instructions below, and open a pull reuqest.

### Adding Config Options

To add config options, include the new config options in *both* `config_spec.yaml` and `assets/Haven.conf.template`, adhering to the syntax and conventions of those files. To view the full list of config options, complete with descriptions and specifications, check out this [site](https://jlopp.github.io/Haven-core-config-generator) from Jameson Lopp.

## Dependencies

Install the following system dependencies to build this project by following the instructions on the provided links:

- [docker](https://docs.docker.com/get-docker)
- [docker-buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [rust-musl-cross](https://github.com/Start9Labs/rust-musl-cross)
- [yq](https://mikefarah.gitbook.io/yq)
- [rust](https://rustup.rs)
- [appmgr](https://github.com/Start9Labs/appmgr)
- [make](https://www.gnu.org/software/make/)

## Cloning

Clone the project locally. Note the submodule link to the original project(s). 

```
git clone git@github.com:Start9Labs/Havend-wrapper.git
cd Havend-wrapper
git submodule update --init
```

## Building

To build the project, run the following commands:

```
make
```
Note: some parts of the make process must be run on armv7

## Installing (on Embassy)

SSH into an Embassy device.
`scp` the `.s9pk` to any directory from your local machine.
Run the following command to determine successful install:

```
appmgr install Havend.s9pk
```
## Integrations

Documentation guides for integrating with external applications can be found under [docs/integrations](/docs/integrations).