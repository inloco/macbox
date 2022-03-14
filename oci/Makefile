RST := $(shell tput sgr0)
BLD := $(shell tput bold)
RED := $(shell tput setaf 1)
GRN := $(shell tput setaf 2)
YLW := $(shell tput setaf 3)
BLU := $(shell tput setaf 4)
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
	skopeo copy "dir://$$(pwd)/build" 'docker://public.ecr.aws/incognia/macbox:${TAG}'
.PHONY: push

latest:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	skopeo copy 'docker://public.ecr.aws/incognia/macbox:${TAG}' 'docker://public.ecr.aws/incognia/macbox:latest'
.PHONY: push

build/manifest.json: box2dir.sh ../pkr/packer_macbox_vmware.box 
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	./box2dir.sh ../pkr/packer_macbox_vmware.box
