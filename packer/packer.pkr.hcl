packer {
  required_plugins {
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
  }
}

source "vagrant" "box" {
  add_force    = true
  communicator = "ssh"
  provider     = "virtualbox"
  source_path  = "generic/ubuntu2204"
}

build {
  sources = ["source.vagrant.box"]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "./script.sh"
  }

}
