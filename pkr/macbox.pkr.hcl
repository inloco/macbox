packer {
  required_version = ">= 1.7.0"
}

source "vmware-iso" "macbox" {
  # VMware-ISO Builder Configuration Reference
  disk_size = 64000
  cdrom_adapter_type = "sata"
  guest_os_type = "darwin21-64"
  version = 18
  // vm_name
  // vmx_disk_template_path
  // vmx_template_path

  # Extra Disk Configuration
  // disk_additional_size = []
  disk_adapter_type = "nvme"
  // vmdk_name = ""
  disk_type_id = 0

  # ISO Configuration
  iso_checksum = "file:./build/Install macOS.cdr.sum"
  iso_url = "./build/Install macOS.cdr"
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
    "../pkg/build/MacBox.pkg",
    "./install.sh",
  ]
  // cd_label = "packer"

  # Output configuration
  // output_directory = "BUILDNAME"
  // output_filename = "vm_name"

  # Run configuration
  // headless = false
  // vrdp_bind_address = "127.0.0.1"
  // vrdp_port_min = 5900
  // vrdp_port_max = 6000

  # Shutdown configuration
  shutdown_command = "sudo /var/root/.local/bin/poweroff"
  // shutdown_timeout = "5m"
  // post_shutdown_delay = "0s"
  // disable_shutdown = false
  // acpi_shutdown = false

  # Hardware configuration
  cpus = 4
  memory = 16384
  cores = 4
  network = "nat"
  network_adapter_type = "e1000e"
  // network_name = ""
  sound = true
  usb = true
  // serial = ""

  # Tools configuration
  // tools_upload_flavor = "darwin"
  // tools_upload_path = ""
  // tools_source_path = ""

  # VMX configuration
  vmx_data = {
    "board-id.reflectHost": "TRUE",
    "sata1.present": "TRUE",
    "sata1:1.deviceType": "cdrom-image",
    "sata1:1.fileName": "/Applications/VMware Fusion.app/Contents/Library/isoimages/darwin.iso",
    "sata1:1.present": "TRUE",
    "smbios.restrictSerialCharset": "TRUE",
    "smc.present": "TRUE",
    "ulm.disableMitigations": "TRUE",
    "usb_xhci.present": "TRUE",
  }
  vmx_data_post = {
    "sata1.present": "FALSE",
    "sata2.present": "FALSE",
  }
  // vmx_remove_ethernet_interfaces = false
  // display_name = ""

  # Export configuration
  format = "vmx"
  // ovftool_options = []
  // skip_export = false
  // keep_registered = false
  // skip_compaction = false

  # Communicator configuration
  communicator = "ssh"
  // pause_before_connecting = "0s"
  // host_port_min = 2222
  // host_port_max = 4444
  // skip_nat_mapping = false
  // ...
  ssh_username = "vagrant"
  ssh_password = "vagrant"
  // ...
  ssh_timeout = "30m"
  // ...

  # Boot Configuration
  // boot_keygroup_interval = "500ms"
  boot_wait = "1m"
  boot_command = [
    "<enter><wait1s250ms>",
    "<leftSuperOn><f5><leftSuperOff><wait1s250ms>",
    "<leftCtrlOn><leftAltOn>m<leftAltOff><leftCtrlOff>",
    "u<enter>",
    "t<enter>",
    "<leftSuperOn><f5><leftSuperOff><wait1s250ms>",
    ". /Volumes/packer/install.sh<enter><wait1s250ms>",
  ]

  # SSH key pair automation
  // ...
}

build {
  name = "macbox"

  sources = [
    "sources.vmware-iso.macbox",
  ]

  post-processors {
    post-processor "vagrant" {
      keep_input_artifact = false
    }

    // post-processor "vagrant-cloud" {
    //   access_token = "${var.cloud_token}"
    //   box_tag      = "incognia/macos"
    //   version      = "${local.version}"
    // }
  }
}
