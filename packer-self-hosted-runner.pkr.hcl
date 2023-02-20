variable "ssh_user" {
  type    = string
  default = "ubuntu"
}

variable "gh_runner_config_token" {
  type      = string
  sensitive = true
}

locals {
  timestamp = formatdate("YYYYMMDD", timestamp())
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "GitHub-self-hosted-runner-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "eu-central-1"
  ssh_username  = var.ssh_user
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      architecture        = "x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "ansible" {
    playbook_file = "./ansible/ansible-self-hosted-runner.yaml"
    user          = var.ssh_user
    use_proxy     = false
    extra_arguments = [
      "--extra-vars",
      "gh_runner_config_token=${var.gh_runner_config_token}",
    ]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}
