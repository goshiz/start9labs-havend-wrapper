ASSETS := $(shell yq r manifest.yaml assets.*.src)
ASSET_PATHS := $(addprefix assets/,$(ASSETS))
VERSION := $(shell toml get haven/Cargo.toml package.version)
HAVEN_SRC := $(shell find ./haven/src) haven/Cargo.toml haven/Cargo.lock

.DELETE_ON_ERROR:

all: haven.s9pk

install: haven.s9pk
	appmgr install haven.s9pk

haven.s9pk: manifest.yaml config_spec.yaml config_rules.yaml image.tar instructions.md $(ASSET_PATHS)
	appmgr -vv pack $(shell pwd) -o haven.s9pk
	appmgr -vv verify haven.s9pk

instructions.md: README.md
	cp README.md instructions.md

image.tar: Dockerfile docker_entrypoint.sh haven/target/armv7-unknown-linux-musleabihf/release/haven
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/haven --platform=linux/arm/v7 -o type=docker,dest=image.tar .

haven/target/armv7-unknown-linux-musleabihf/release/haven: $(HAVEN_SRC)
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/haven:/home/rust/src start9/rust-musl-cross:armv7-musleabihf cargo +beta build --release
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/haven:/home/rust/src start9/rust-musl-cross:armv7-musleabihf musl-strip target/armv7-unknown-linux-musleabihf/release/haven

manifest.yaml: haven/Cargo.toml
	yq w -i manifest.yaml version $(VERSION)