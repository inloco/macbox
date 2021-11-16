RST := \33[m
BLD := \33[1m
RED := \33[31m
GRN := \33[32m
YLW := \33[33m
BLU := \33[34m
EOL := \n

TAG ?= latest

all: build/manifest.json
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
.PHONY: all

clean:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	rm -fR build/
.PHONY: clean

push:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	skopeo copy "dir://$$(pwd)/build" 'docker://ghcr.io/inloco/macbox:${TAG}'
.PHONY: push

latest:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	skopeo copy 'docker://ghcr.io/inloco/macbox:${TAG}' 'docker://ghcr.io/inloco/macbox:latest'
.PHONY: push

build/manifest.json: box2dir.sh ../pkr/packer_macbox_vmware.box 
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	./box2dir.sh ../pkr/packer_macbox_vmware.box
