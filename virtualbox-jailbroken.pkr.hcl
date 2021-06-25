packer {
  required_version = ">= 1.7.0"
}

source "virtualbox-ovf" "virtualbox-jailbroken" {
  checksum = "none"
  source_path = "./output-virtualbox-jailed/packer-virtualbox-jailed.ovf"
  // import_flags = []
  // import_opts = ""
  // target_path = ""
  // vm_name = ""
  // keep_registered = false
  // skip_export = false
  // virtualbox_version_file = ""
  guest_additions_mode = "disable"
  // guest_additions_interface = ""
  // guest_additions_path = ""
  // guest_additions_sha256 = ""
  // guest_additions_url = ""

  # ISO Configuration
  guest_additions_interface = "sata"
  // guest_additions_sha256 = "file:./build/Install macOS Big Sur.cdr.sum"
  // guest_additions_url = "./build/Install macOS Big Sur.cdr"
  // iso_urls = []
  // iso_target_path = ""
  // iso_target_extension = ""

  # CD configuration
  cd_files = [
    "/usr/local/sbin/dropbear",
    "./jailbreak.sh",
  ]
  // cd_label = "packer"

  # Shutdown configuration
  shutdown_command = "/sbin/shutdown -h now"
  // shutdown_timeout = "5m"
  // post_shutdown_delay = "0s"
  // disable_shutdown = false
  // acpi_shutdown = false

  # VBox Manage configuration
  vboxmanage = [
    [
      "storagectl",
      "{{.Name}}",
      "--name",
      "IDE Controller",
      "--remove",
    ],
    [
      "storageattach",
      "{{.Name}}",
      "--storagectl",
      "SATA Controller",
      "--port",
      "1",
      "--type",
      "dvddrive",
      "--medium",
      "./build/Install macOS Big Sur.cdr",
    ],
  ]
  // vboxmanage_post = []

  # Communicator configuration
  communicator = "ssh"
  // pause_before_connecting = "0s"
  // host_port_min = 2222
  // host_port_max = 4444
  // skip_nat_mapping = false
  // ...
  ssh_port = 2222
  ssh_username = "root"
  ssh_password = "toor"
  // ...

  # Boot Configuration
  // boot_keygroup_interval = "500ms"
  boot_wait = "2m30s"
  boot_command = [
    "<enter><wait15s>",
    "<leftSuperOn><f5><leftSuperOff><wait3s>",
    "<leftCtrlOn><leftAltOn>m<leftAltOff><leftCtrlOff>",
    "u<enter>",
    "t<enter>",
    "<leftSuperOn><f5><leftSuperOff><wait3s>",
    ". /Volumes/packer/jailbreak.sh<enter><wait3s>",
  ]
}

build {
  name = "virtualbox-jailbroken"

  sources = [
    "sources.virtualbox-ovf.virtualbox-jailbroken",
  ]
}
