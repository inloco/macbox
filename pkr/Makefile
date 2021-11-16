RST := \33[m
BLD := \33[1m
RED := \33[31m
GRN := \33[32m
YLW := \33[33m
BLU := \33[34m
EOL := \n

BOX_NAME ?= incognia/macbox
PROVIDER ?= vmware_fusion
VAGRANT_HOME ?= $(shell printf "$${VAGRANT_HOME:-$${HOME}/.vagrant.d}")
INSTALL_PATH ?= $(shell printf "${VAGRANT_HOME}/boxes/$$(printf "${BOX_NAME}" | sed 's|/|-VAGRANTSLASH-|g')/0/${PROVIDER}")

all: packer_macbox_vmware.box
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
.PHONY: all

install: ${INSTALL_PATH}/metadata.json
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
.PHONY: install

clean:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	rm -fR build/ output-*/ packer_cache/ *.box
.PHONY: clean

remove:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	rm -fR ${INSTALL_PATH}/
.PHONY: remove

/Applications/Install\ macOS\ *.app:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	softwareupdate --fetch-full-installer

build/...:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	mkdir -p build/.
	@printf '${BLD}${YLW}$$${RST} '
	touch build/...

build/Install\ macOS.sparseimage: /Applications/Install\ macOS\ *.app build/...
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	hdiutil create -size 20g -layout SPUD -fs HFS+ -volname Install\ macOS -type SPARSE build/Install\ macOS.sparseimage
	@printf '${BLD}${YLW}$$${RST} '
	hdiutil attach -noverify build/Install\ macOS.sparseimage
	@printf '${BLD}${YLW}$$${RST} '
	sudo /Applications/Install\ macOS\ *.app/Contents/Resources/createinstallmedia --downloadassets --nointeraction --volume /Volumes/Install\ macOS/
	@printf '${BLD}${YLW}$$${RST} '
	hdiutil eject -force /Volumes/Install\ macOS\ */
	@printf '${BLD}${YLW}$$${RST} '
	hdiutil resize -size min build/Install\ macOS.sparseimage

build/Install\ macOS.cdr: build/... build/Install\ macOS.sparseimage
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	hdiutil convert -format UDTO -o build/Install\ macOS.cdr build/Install\ macOS.sparseimage

packer_macbox_vmware.box: macbox.pkr.hcl install.sh build/Install\ macOS.cdr ../pkg/build/MacBox.pkg
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	packer init macbox.pkr.hcl
	@printf '${BLD}${YLW}$$${RST} '
	packer build -timestamp-ui macbox.pkr.hcl

${INSTALL_PATH}/metadata.json: packer_macbox_vmware.box
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	rm -fR ${INSTALL_PATH}/
	@printf '${BLD}${YLW}$$${RST} '
	mkdir -p ${INSTALL_PATH}/
	@printf '${BLD}${YLW}$$${RST} '
	tar -zxvf packer_macbox_vmware.box -C ${INSTALL_PATH}/
