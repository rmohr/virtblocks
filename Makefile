all: build

virtblocks-language:
	@if ! test "$(VIRTBLOCKS_LANGUAGE)"; then \
	  echo "error: No language selected" 2>&1; \
	  echo "Use 'make VIRTBLOCKS_LANGUAGE=(rust|golang)' or" 2>&1; \
	  echo "run 'export VIRTBLOCKS_LANGUAGE=(rust|golang)' beforehand" 2>&1; \
	  exit 1; \
	fi

fmt: virtblocks-language fmt-$(VIRTBLOCKS_LANGUAGE)
verify-fmt: virtblocks-language verify-fmt-$(VIRTBLOCKS_LANGUAGE)
vet: virtblocks-language vet-$(VIRTBLOCKS_LANGUAGE)
build: virtblocks-language build-$(VIRTBLOCKS_LANGUAGE)
clean: virtblocks-language clean-$(VIRTBLOCKS_LANGUAGE)

.PHONY: all virtblocks-language fmt verify-fmt vet build clean

fmt-golang:
	go fmt ./...

verify-fmt-golang:
	scripts/verify-gofmt.sh

vet-golang:
	go vet ./go/native/...

build-golang:
	$(MAKE) -C c/go/ build

clean-golang:
	$(MAKE) -C c/go/ clean

.PHONY: fmt-golang verify-fmt-golang vet-golang build-golang clean-golang

fmt-rust:
	cargo fmt

verify-fmt-rust:
	cargo fmt -- --check

vet-rust:
	cargo clippy

build-rust:
	$(MAKE) -C c/rust/ build

clean-rust:
	$(MAKE) -C c/rust/ clean

.PHONY: fmt-rust verify-fmt-rust vet-rust build-rust clean-rust
