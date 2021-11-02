RST := $(shell tput sgr0)
BLD := $(shell tput bold)
RED := $(shell tput setaf 1)
GRN := $(shell tput setaf 2)
YLW := $(shell tput setaf 3)
BLU := $(shell tput setaf 4)
EOL := \n

all: packer_macbox_vmware.box
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
.PHONY: all

clean:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	rm -fR build/ output-*/ packer_cache/ *.box
.PHONY: clean

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
	sudo /Applications/Install\ macOS\ *.app/Contents/Resources/createinstallmedia --downloadassets --nointeraction --volume /Volumes/Install\ macOS
	@printf '${BLD}${YLW}$$${RST} '
	hdiutil eject -force /Volumes/Install\ macOS\ *
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
	packer build macbox.pkr.hcl
