packer {
  required_version = ">= 1.7.0"

  required_plugins {
    vmware = {
      source  = "github.com/hashicorp/vmware"
      version = ">= 1.0.1"
    }
  }
}

source "vmware-iso" "macbox" {
  # VMware-ISO Builder Configuration Reference
  disk_size          = 256000
  cdrom_adapter_type = "sata"
  guest_os_type      = "darwin21-64"
  version            = 18

  # Extra Disk Configuration
  disk_adapter_type = "nvme"
  disk_type_id      = 0

  # ISO Configuration
  iso_checksum = "none"
  iso_url      = "./build/Install macOS.cdr"

  # CD configuration
  cd_files = [
    "../pkg/build/MacBox.pkg",
    "./install.sh",
  ]

  # Shutdown configuration
  shutdown_command = "sudo /var/root/.local/bin/poweroff"

  # Hardware configuration
  cores                = 1
  cpus                 = 2
  memory               = 8192
  network              = "nat"
  network_adapter_type = "e1000e"
  usb                  = true

  # Run configuration
  headless = true

  # VMX configuration
  vmx_data = {
    "isolation.tools.hgfs.disable" = "TRUE"
    "sata0:1.deviceType"           = "cdrom-image"
    "sata0:1.fileName"             = "/Applications/VMware Fusion.app/Contents/Library/isoimages/darwin.iso"
    "sata0:1.present"              = "TRUE"
    "sata1.present"                = "TRUE"
    "smbios.restrictSerialCharset" = "TRUE"
    "smc.present"                  = "TRUE"
    "ulm.disableMitigations"       = "TRUE"
    "vhv.enable"                   = "TRUE"
    "vvtd.enable"                  = "TRUE"
  }
  vmx_data_post = {
    "bios.bootorder" = "hdd"
  }
  vmx_remove_ethernet_interfaces = true

  # Export configuration
  format = "vmx"

  # Communicator configuration
  communicator = "ssh"
  ssh_username = "vagrant"
  ssh_password = "vagrant"
  ssh_timeout  = "1h30m"

  # Boot Configuration
  boot_wait = "2m"
  boot_command = [
    "<enter><wait6s>",
    "<leftSuperOn><f5><leftSuperOff><wait1s>",
    "<leftCtrlOn><leftAltOn>m<leftAltOff><leftCtrlOff>",
    "u<enter>",
    "t<enter>",
    "<leftSuperOn><f5><leftSuperOff><wait5s>",
    ". /Volumes/packer/install.sh<enter>",
  ]
}

build {
  name = "macbox"

  sources = [
    "sources.vmware-iso.macbox",
  ]

  post-processor "shell-local" {
    inline = [
      "sed -E -e '/^(checkpoint|cleanshutdown|ehci|floppy|gui|hgfs|parallel|remotedisplay|replay|sata|scsi|serial|sound|vmci|vmotion)[ .0-9:]/d' -i '' './output-{{build_name}}/packer-{{build_name}}.vmx'",
    ]
  }

  post-processor "vagrant" {
    compression_level = 9
  }
}
