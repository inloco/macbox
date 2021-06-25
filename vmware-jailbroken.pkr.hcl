packer {
  required_version = ">= 1.7.0"
}

source "vmware-vmx" "vmware-jailbroken" {
  # VMware-VMX Builder Configuration Reference
  source_path = "./output-vmware-jailed/packer-vmware-jailed.vmx"
  // linked = false
  // attach_snapshot = "null/empty"
  // vm_name = BUILDNAME

  # Extra Disk Configuration
  // disk_additional_size = []
  disk_adapter_type = "nvme"
  // vmdk_name = ""
  disk_type_id = 0

  # VMX configuration
  vmx_data = {
    "bios.forceSetupOnce": "TRUE",
    "sata1.present": "TRUE",
    "sata1:1.deviceType": "cdrom-image",
    "sata1:1.fileName": "/Users/pedro/repos/mac-box/build/Install macOS Big Sur.cdr",
    "sata1:1.present": "TRUE",
  }
  vmx_data_post = {
    "bios.forceSetupOnce": "FALSE",
    "sata1.present": "FALSE",
  }
  // vmx_remove_ethernet_interfaces = false
  // display_name = ""

  # CD configuration
  cd_files = [
    "./jailbreak.sh",
  ]
  // cd_label = "packer"

  # Export configuration
  format = "ovf"
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
  ssh_username = "user"
  ssh_password = "pass"
  // ...
  ssh_timeout = "90m"
  // ...

  # Boot Configuration
  // boot_keygroup_interval = "500ms"
  boot_wait = "2m30s"
  boot_command = [
    "<enter><wait5m>",
    "<leftSuperOn><f5><leftSuperOff><wait5s>",
    "<leftCtrlOn><leftAltOn>m<leftAltOff><leftCtrlOff>",
    "u<enter>",
    "t<enter>",
    "<leftSuperOn><f5><leftSuperOff><wait5s>",
    ". /Volumes/packer/jailbreak.sh<enter><wait45m>",
  ]

  # SSH key pair automation
  // ...
}

build {
  name = "vmware-jailbroken"

  sources = [
    "sources.vmware-vmx.vmware-jailbroken",
  ]
}
