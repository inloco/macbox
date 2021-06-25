packer {
  required_version = ">= 1.7.0"
}

source "virtualbox-iso" "virtualbox-jailed" {
  # VirtualBox-ISO Builder Configuration Reference
  chipset = "ich9"
  firmware = "efi"
  nested_virt = false
  rtc_time_base = "UTC"
  disk_size = 64000
  nic_type = "82545EM"
  audio_controller = "hda"
  gfx_controller = "vboxvga"
  gfx_vram_size = 128
  gfx_accelerate_3d = true
  // gfx_efi_resolution = ""
  guest_os_type = "MacOS1013_64"
  hard_drive_discard = true
  hard_drive_interface = "sata"
  // sata_port_count = 2
  // nvme_port_count = 1
  hard_drive_nonrotational = true
  iso_interface = "sata"
  // disk_additional_size = []
  keep_registered = true
  skip_export = false
  // vm_name = ""
  // virtualbox_version_file = ""
  bundle_iso = false
  guest_additions_mode = "attach"
  guest_additions_interface = "sata"
  // guest_additions_path = ""
  // guest_additions_sha256 = ""
  // guest_additions_url = ""

  # ISO Configuration
  iso_checksum = "file:./build/Install macOS Big Sur.cdr.sum"
  iso_url = "./build/Install macOS Big Sur.cdr"
  // iso_urls = []
  // iso_target_path = ""
  // iso_target_extension = ""

  # Http directory configuration
  // http_directory = ""
  // http_content = {}
  // http_port_min = 8000
  // http_port_max = 9000
  // http_bind_address = "0.0.0.0"

  # Floppy configuration
  // floppy_files = []
  // floppy_dirs = []
  // floppy_label = ""

  # CD configuration
  cd_files = [
    "./install.sh",
    "./build/MacBox.pkg",
  ]
  // cd_label = "packer"

  # Export configuration
  // format = "ovf"
  // export_opts = []

  # Output configuration
  // output_directory = "BUILDNAME"
  // output_filename = "vm_name"

  # Run configuration
  // headless = false
  // vrdp_bind_address = "127.0.0.1"
  // vrdp_port_min = 5900
  // vrdp_port_max = 6000

  # Shutdown configuration
  shutdown_command = "sudo shutdown -h now"
  // shutdown_timeout = "5m"
  // post_shutdown_delay = "0s"
  // disable_shutdown = false
  // acpi_shutdown = false

  # Hardware configuration
  cpus = 4
  memory = 16384
  sound = "coreaudio"
  usb = true

  # VBox Manage configuration
  vboxmanage = [
    [
      "modifyvm",
      "{{.Name}}",
      "--keyboard",
      "usb",
    ],
    [
      "modifyvm",
      "{{.Name}}",
      "--mouse",
      "usbtablet",
    ],
    [
      "storagectl",
      "{{.Name}}",
      "--name",
      "IDE Controller",
      "--remove",
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
  ssh_username = "user"
  ssh_password = "pass"
  // ...
  ssh_timeout = "90m"
  // ...

  # Boot Configuration
  // boot_keygroup_interval = "500ms"
  boot_wait = "3m"
  boot_command = [
    "<enter><wait3s>",
    "<leftSuperOn><f5><leftSuperOff><wait3s>",
    "<leftCtrlOn><leftAltOn>m<leftAltOff><leftCtrlOff>",
    "u<enter>",
    "t<enter>",
    "<leftSuperOn><f5><leftSuperOff><wait3s>",
    ". /Volumes/packer/install.sh<enter><wait3s>",
  ]

  # SSH key pair automation
  // ...
}

build {
  name = "virtualbox-jailed"

  sources = [
    "sources.virtualbox-iso.virtualbox-jailed",
  ]
}
