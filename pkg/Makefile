RST := \033[m
BLD := \033[1m
RED := \033[31m
GRN := \033[32m
YLW := \033[33m
BLU := \033[34m
EOL := \n

all: build/MacBox.pkg
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
.PHONY: all

clean:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	rm -fR build/
.PHONY: clean

build/...:
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	mkdir -p build/.
	@printf '${BLD}${YLW}$$${RST} '
	touch build/...

build/authorized_keys: build/...
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	wget -O build/authorized_keys https://raw.githubusercontent.com/hashicorp/vagrant/HEAD/keys/vagrant.pub

build/id_rsa: build/...
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	wget -O build/id_rsa https://raw.githubusercontent.com/hashicorp/vagrant/HEAD/keys/vagrant

build/id_rsa.pub: build/...
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	wget -O build/id_rsa.pub https://raw.githubusercontent.com/hashicorp/vagrant/HEAD/keys/vagrant.pub

build/user.sh build/group.sh build/screensaver_root.sh build/screensaver_host.sh build/SetupAssistant.sh build/loginwindow_root.sh build/loginwindow_home.sh build/SoftwareUpdate.sh build/commerce.sh build/kcpassword: make.py build/...
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	python3 make.py

build/MacBox.pkg: MacBox.pkgproj postinstall.sh res/jailbreak.sh res/setup.sh res/loginhook.sh res/logouthook.sh res/poweroff.applescript build/authorized_keys build/id_rsa build/id_rsa.pub build/user.sh build/group.sh build/screensaver_root.sh build/screensaver_host.sh build/SetupAssistant.sh build/loginwindow_root.sh build/loginwindow_home.sh build/SoftwareUpdate.sh build/commerce.sh build/kcpassword
	@printf '${BLD}${RED}make: *** [$@]${RST}${EOL}'
	@printf '${BLD}${YLW}$$${RST} '
	packagesbuild -v MacBox.pkgproj
