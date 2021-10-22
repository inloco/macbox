RST := $(shell tput sgr0)
BLD := $(shell tput bold)
RED := $(shell tput setaf 1)
GRN := $(shell tput setaf 2)
YLW := $(shell tput setaf 3)
BLU := $(shell tput setaf 4)
EOL := \n

all: output-macbox/packer-macbox.vmx
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
.PHONY: all

clean:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	rm -fR build/ output-*/ packer_cache/
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

build/Install\ macOS.cdr: build/Install\ macOS.sparseimage
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	hdiutil convert -format UDTO -o build/Install\ macOS.cdr build/Install\ macOS.sparseimage

build/Install\ macOS.cdr.sum: build/Install\ macOS.cdr
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	sha256sum build/Install\ macOS.cdr > build/Install\ macOS.cdr.sum

build/authorized_keys:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	wget -O build/authorized_keys https://raw.githubusercontent.com/hashicorp/vagrant/HEAD/keys/vagrant.pub

build/id_rsa:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	wget -O build/id_rsa https://raw.githubusercontent.com/hashicorp/vagrant/HEAD/keys/vagrant

build/id_rsa.pub:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	wget -O build/id_rsa.pub https://raw.githubusercontent.com/hashicorp/vagrant/HEAD/keys/vagrant.pub

build/user.sh build/group.sh build/screensaver_root.sh build/screensaver_host.sh build/SetupAssistant.sh build/loginwindow_root.sh build/loginwindow_home.sh build/kcpassword: make.py build/...
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	python3 make.py

build/MacBox.pkg: MacBox.pkgproj postinstall.sh setup.sh jailbreak.sh logouthook.sh build/authorized_keys build/id_rsa build/id_rsa.pub build/user.sh build/group.sh build/screensaver_root.sh build/screensaver_host.sh build/SetupAssistant.sh build/loginwindow_root.sh build/loginwindow_home.sh build/kcpassword
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	packagesbuild -v MacBox.pkgproj

output-macbox/packer-macbox.vmx packer_macbox_vmware.box: macbox.pkr.hcl install.sh build/MacBox.pkg build/Install\ macOS.cdr.sum
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	packer build macbox.pkr.hcl
