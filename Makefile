ASSETS := $(shell yq e ".assets.[].src" manifest.yaml)
ASSET_PATHS := $(addprefix assets/,$(ASSETS))
VERSION := $(shell yq e ".version" manifest.yaml)
HAVEN_SRC := $(shell find ./haven -name '*.rs') haven/Cargo.toml haven/Cargo.lock

.DELETE_ON_ERROR:

all: havend.s9pk

install: havend.s9pk
	appmgr install havend.s9pk

havend.s9pk: manifest.yaml config_spec.yaml config_rules.yaml image.tar instructions.md $(ASSET_PATHS)
	appmgr -vv pack $(shell pwd) -o havend.s9pk
	appmgr -vv verify havend.s9pk

instructions.md: README.md
	cp README.md instructions.md

image.tar: Dockerfile docker_entrypoint.sh haven/target/armv7-unknown-linux-musleabihf/release/havend manifest.yaml
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/havend --platform=linux/arm/v7 -o type=docker,dest=image.tar .

haven/target/armv7-unknown-linux-musleabihf/release/havend: $(HAVEN_SRC)
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/haven:/home/rust/src start9/rust-musl-cross:armv7-musleabihf cargo +beta build --release
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/haven:/home/rust/src start9/rust-musl-cross:armv7-musleabihf musl-strip target/armv7-unknown-linux-musleabihf/release/havend

