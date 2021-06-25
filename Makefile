RST := $(shell tput sgr0)
BLD := $(shell tput bold)
RED := $(shell tput setaf 1)
GRN := $(shell tput setaf 2)
YLW := $(shell tput setaf 3)
BLU := $(shell tput setaf 4)
EOL := \n

all: output-virtualbox-jailbroken/packer-virtualbox-jailbroken.ovf
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
.PHONY: all

clean:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	rm -fR build/ output-*/ packer_cache/
.PHONY: clean

/Applications/Install\ macOS\ Big\ Sur.app:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	softwareupdate --fetch-full-installer

build/...:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	mkdir -p build/.
	@printf '${BLD}${YLW}$$${RST} '
	touch build/...

build/Install\ macOS\ Big\ Sur.sparseimage: /Applications/Install\ macOS\ Big\ Sur.app build/...
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	hdiutil create -size 20g -layout SPUD -fs HFS+ -volname 'Install macOS Big Sur' -type SPARSE build/'Install macOS Big Sur.sparseimage'
	@printf '${BLD}${YLW}$$${RST} '
	hdiutil attach -noverify build/'Install macOS Big Sur.sparseimage'
	@printf '${BLD}${YLW}$$${RST} '
	sudo '/Applications/Install macOS Big Sur.app/Contents/Resources/createinstallmedia' --downloadassets --nointeraction --volume '/Volumes/Install macOS Big Sur'
	@printf '${BLD}${YLW}$$${RST} '
	hdiutil eject -force '/Volumes/Install macOS Big Sur'
	@printf '${BLD}${YLW}$$${RST} '
	hdiutil resize -size min build/'Install macOS Big Sur.sparseimage'

build/Install\ macOS\ Big\ Sur.cdr: build/Install\ macOS\ Big\ Sur.sparseimage
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	hdiutil convert -format UDTO -o build/'Install macOS Big Sur.cdr' build/'Install macOS Big Sur.sparseimage'

build/Install\ macOS\ Big\ Sur.cdr.sum: build/Install\ macOS\ Big\ Sur.cdr
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	sha256sum build/'Install macOS Big Sur.cdr' > build/'Install macOS Big Sur.cdr.sum'

build/user.sh build/admin.sh build/com.apple.SetupAssistant.sh build/com.apple.loginwindow.sh build/kcpassword: make.py build/...
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	python3 make.py

build/MacBox.pkg: MacBox.pkgproj postinstall.sh build/user.sh build/admin.sh build/com.apple.SetupAssistant.sh build/com.apple.loginwindow.sh build/kcpassword
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	packagesbuild -v MacBox.pkgproj

output-virtualbox-jailed/packer-virtualbox-jailed.ovf: virtualbox-jailed.pkr.hcl install.sh build/MacBox.pkg build/Install\ macOS\ Big\ Sur.cdr.sum
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	packer build virtualbox-jailed.pkr.hcl
	@printf '${BLD}${YLW}$$${RST} '
	cd output-virtualbox-jailed && ln -s packer-virtualbox-jailed-*.ovf packer-virtualbox-jailed.ovf

output-virtualbox-jailbroken/packer-virtualbox-jailbroken.ovf: virtualbox-jailbroken.pkr.hcl jailbreak.sh output-virtualbox-jailed/packer-virtualbox-jailed.ovf
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	packer build virtualbox-jailbroken.pkr.hcl
	@printf '${BLD}${YLW}$$${RST} '
	cd output-virtualbox-jailbroken && ln -s packer-virtualbox-jailbroken-*.ovf packer-virtualbox-jailbroken.ovf

output-vmware-jailed/packer-vmware-jailed.ovf: vmware-jailed.pkr.hcl install.sh build/MacBox.pkg build/Install\ macOS\ Big\ Sur.cdr.sum
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	packer build vmware-jailed.pkr.hcl

output-vmware-jailbroken/packer-vmware-jailbroken.ovf: vmware-jailbroken.pkr.hcl jailbreak.sh output-vmware-jailed/packer-vmware-jailed.ovf
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	packer build vmware-jailbroken.pkr.hcl
