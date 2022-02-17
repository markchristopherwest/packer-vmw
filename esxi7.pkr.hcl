# https://learn.hashicorp.com/tutorials/packer/hcp-push-image-metadata?in=packer/hcp-get-started
packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# https://www.packer.io/docs/templates/hcl_templates/blocks/locals

locals {

  # Image Basics
  about_my_source    = "github.com/${var.product_vendor}/${var.product_name}"
  date_ttl_birth     = formatdate("YYYY-MM-DD'T'hh:mm:ssZ", timestamp())
  date_ttl_death     = formatdate("YYYY-MM-DD'T'hh:mm:ssZ", timeadd(local.date_ttl_birth, "2160h"))
  path_key_consul    = var.PATH_KEY_CONSUL
  path_key_nomad     = var.PATH_KEY_NOMAD
  path_key_terraform = var.PATH_KEY_TERRAFORM
  path_key_vault     = var.PATH_KEY_VAULT
  product_vendor     = var.product_vendor
  product_repo       = var.product_name
  release_tag        = var.version

  build_scope_aws = [{
    name   = "m6g.medium"
    arch   = "arm64"
    region = "us-east-1"
    }, {
    name   = "t3a.medium"
    arch   = "amd64"
    region = "us-east-1"
  }]

  build_scope_gcloud = [{
    name   = "n2-standard-2"
    arch   = "intel"
    region = "us-west1-a"
    }, {
    name   = "n1.medium"
    arch   = "amd"
    region = "t2d-standard-1"
  }]

  build_scope_azure = [{
    name   = "Standard_DS1_v2"
    arch   = "arm64"
    region = "West Europe"
    }, {
    name   = "t3a.micro"
    arch   = "amd64"
    region = "us-east-1"
  }]
  build_scope_qemu = [{
    name   = "virt-6.2"
    arch   = "arm64"
    region = "us-east-1"
    }, {
    name   = "q35,accel=hvf"
    arch   = "amd64"
    region = "us-east-1"
  }]

  product_core = [
    {
      name    = "boundary"
      version = "0.7.4"
    },
    {
      name     = "consul"
      lic_path = var.PATH_KEY_CONSUL
      version  = "1.11.2"
    },
    {
      name     = "nomad"
      lic_path = var.PATH_KEY_NOMAD
      version  = "1.2.5"
    },
    {
      name    = "packer"
      version = "1.7.10"
    },
    {
      name     = "terraform"
      lic_path = var.PATH_KEY_TERRAFORM
      version  = "1.1.5"
    },
    {
      name     = "vault"
      lic_path = var.PATH_KEY_VAULT
      version  = "1.9.3"
    },
    {
      name    = "waypoint"
      version = "0.7.1"
    }
  ]

  product_extras = [
    {
      name    = "consul-replicate"
      version = "0.4.0"
    },
    {
      name    = "consul-template"
      version = "0.27.2"
    },
    {
      name    = "consul-terraform-sync"
      version = "0.4.3"
    },
    {
      name    = "vault-ssh-helper"
      version = "0.2.1"
    },
    {
      name    = "waypoint-entrypoint"
      version = "0.7.1"
    }
  ]

  product_utils = [
    {
      name    = "hcdiag"
      version = "0.1.1"
    },
    {
      name    = "sentinel"
      version = "0.18.5"
    }
  ]

  settings_file  = "${path.cwd}/settings.txt"
  scripts_folder = "${path.root}/scripts"
  standard_tags = {

    about_author           = var.SOURCE_USER
    about_date_created     = local.date_ttl_birth
    about_date_expires     = local.date_ttl_death
    about_item_product     = var.product_name
    about_item_vendor      = var.product_vendor
    about_item_version     = var.version
    about_sourceos_vendor  = var.os_vendor
    about_sourceos_version = var.os_version
    source_ami_id          = "{{ .SourceAMI }}"
    source_ami_name        = "{{ .SourceAMIName }}"
  }
  root = path.root
}

# https://www.packer.io/guides/hcl/variables

variable "AWS_ACCESS_KEY_ID" {
  type    = string
  default = env("AWS_ACCESS_KEY_ID")
}

variable "AWS_SECRET_ACCESS_KEY" {
  type    = string
  default = env("AWS_SECRET_ACCESS_KEY")
}

variable "AWS_SESSION_TOKEN" {
  type    = string
  default = env("AWS_SESSION_TOKEN")
}

variable "AZURE_CLIENT_ID" {
  type    = string
  default = env("AZURE_CLIENT_ID")
}

variable "AZURE_CLIENT_SECRET" {
  type    = string
  default = env("AZURE_CLIENT_SECRET")
}

variable "AZURE_SUBSCRIPTION_ID" {
  type    = string
  default = env("AZURE_SUBSCRIPTION_ID")
}

variable "AZURE_TENANT_ID" {
  type    = string
  default = env("AZURE_TENANT_ID")
}

variable "GCLOUD_PROJECT_ID" {
  type    = string
  default = env("GCLOUD_PROJECT_ID")
}

variable "preseed_file_name" {
  type    = string
  default = "preseed.cfg"
}

variable "product_vendor" {
  type    = string
  default = "vmware"
}

variable "product_name" {
  type    = string
  default = "vsphere"
}



variable "golang_repo" {
  type    = string
  default = "https://github.com/golang/go.git"
}

variable "golang_version" {
  type    = string
  default = "1.17.5"
}

variable "os_vendor" {
  type    = string
  default = "ubuntu"
}

variable "os_version" {
  type    = string
  default = "20.04"
}

variable "PATH_KEY_CONSUL" {
  type    = string
  default = "/tmp/consul.hclic"
}

variable "PATH_KEY_NOMAD" {
  type    = string
  default = "/tmp/nomad.hclic"
}

variable "PATH_KEY_TERRAFORM" {
  type    = string
  default = "/tmp/key-terraform.rli"
}

variable "PATH_KEY_VAULT" {
  type    = string
  default = "/tmp/vault.hclic"
}

variable "SOURCE_HOST" {
  type    = string
  default = env("HOST")
}

variable "SOURCE_USER" {
  type    = string
  default = env("USER")
}

variable "TOKEN_VAGRANT_CLOUD" {
  type    = string
  default = env("TOKEN_VAGRANT_CLOUD")
}

variable "disk_bus" {
  type    = string
  default = "scsi"
}

variable "disk_size" {
  type    = string
  default = "8192"
}

variable "guest_os_type" {
  type    = string
  default = "vmkernel65"
}

variable "headless" {
  type    = string
  default = "false"
}

variable "http_directory" {
  type    = string
  default = "http"
}

variable "iso_checksum" {
  type    = string
  default = "3a7f8f9ec46c9f3cb3057553b64fbd74251485bf59cc4606b1f5b9450c33ec55"
}

variable "iso_checksum_type" {
  type    = string
  default = "sha256"
}

variable "iso_url" {
  type    = string
  default = "/Users/mark.west/Downloads/VMware-VMvisor-Installer-7.0U3c-19193900.x86_64.iso"
}

variable "memory" {
  type    = string
  default = "10240"
}

variable "output_directory" {
  type    = string
  default = "/Users/mark.west/output-vmware-iso"
}

variable "remove_interfaces" {
  type    = string
  default = "true"
}

variable "save_to_dir" {
  type    = string
  default = "/Users/mark.west/"
}

variable "save_to_filename" {
  type    = string
  default = "/Users/mark.west/esxi7.vmwarevm"
}

variable "shutdown_command" {
  type    = string
  default = "esxcli system maintenanceMode set -e true -t 0; esxcli system shutdown poweroff -d 10 -r \"Packer Shutdown\"; esxcli system maintenanceMode set -e false -t 0"
}

variable "ssh_password" {
  type    = string
  default = "VMw@re1"
}

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "vcpu" {
  type    = string
  default = "2"
}

variable "version" {
  type    = string
  default = "10"
}

variable "vm_name" {
  type    = string
  default = "esxi72_x64"
}

variable "vmx_file" {
  type    = string
  default = "'/Users/mark.west/github/outside/packer-vmware-iso/esxi7.vmx'"
}

source "vmware-iso" "autogenerated_1" {

  boot_command = [
    "<esc><esc><esc><shift>O",
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs> ",
    "kernelopt=runweasel ",
    "bootstate=0 ",
    "title=https://cloud.hashicorp.com/products/packer ",
    "timeout=5 ",
    "prefix= ",
    "ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter>",
  ]
  boot_wait      = "3s"
  cpus           = var.vcpu
  disk_bus       = var.disk_bus
  disk_size      = var.disk_size
  disk_type_id   = 0
  guest_os_type  = var.guest_os_type
  headless       = var.headless
  http_directory = var.http_directory
  iso_checksum   = var.iso_checksum
  # iso_checksum_type       = "${var.iso_checksum_type}"
  iso_url                 = var.iso_url
  memory                  = var.memory
  network                 = "vmnet1"
  network_adapter_type    = "vmxnet3"
  network_name            = "vmnet1"
  output_directory        = var.output_directory
  pause_before_connecting = "10m"
  shutdown_command        = var.shutdown_command
  ssh_password            = var.ssh_password
  ssh_username            = var.ssh_username
  ssh_wait_timeout        = "60m"
  # vnc_over_websocket = true
  insecure_connection = true
  vm_name             = var.vm_name
  vmx_data = {
    "firmware" : "efi"
    "vhv.enable" : "TRUE"
    "ethernet1.present" : "TRUE"
    "ethernet1.connectionType" : "custom"
    "ethernet1.virtualDev" : "vmxnet3"
    "ethernet1.wakeOnPcktRcv" : "FALSE"
    "ethernet1.addressType" : "generated"
    "ethernet1.linkStatePropagation.enable" : "TRUE"
    "ethernet1.vnet" : "vmnet2"
    "ethernet1.bsdName" : "en1"
    "ethernet1.displayName" : "vmnet2 ESX1"
    "ethernet2.present" : "TRUE"
    "ethernet2.connectionType" : "custom"
    "ethernet2.virtualDev" : "vmxnet3"
    "ethernet2.wakeOnPcktRcv" : "FALSE"
    "ethernet2.addressType" : "generated"
    "ethernet2.linkStatePropagation.enable" : "TRUE"
    "ethernet2.vnet" : "vmnet8"
    "ethernet2.bsdName" : "en2"
    "ethernet2.displayName" : "vmnet8 ESX2"
    "scsi0.virtualDev" : "pvscsi",
    "disk.enableUUID" : "TRUE"
  }
  vmx_remove_ethernet_interfaces = var.remove_interfaces
}

build {

  hcp_packer_registry {
    bucket_name = "${var.product_name}-${var.product_vendor}"
    description = <<EOT
    PetShop: Pets vs. Cattle
        EOT
    # https://www.packer.io/docs/templates/hcl_templates/blocks/build/hcp_packer_registry#bucket_labels
    bucket_labels = {
      "vendor_manufacturer" = var.product_vendor,
      "vendor_product"      = var.product_name,
    }
    # https://www.packer.io/docs/templates/hcl_templates/blocks/build/hcp_packer_registry#build_labels
    build_labels = {
      "build_age_birth"   = local.date_ttl_birth,
      "build_age_death"   = local.date_ttl_death,
      "build_drivers"     = "emulex,lsi",
      "build_image_score" = "5",
      "build_image_wiki"  = "https://confluence/vsphere/${var.version}"
      "build_owner_group" = "cloud",
      "build_owner_user"  = var.SOURCE_USER,
      "build_iso_hash"    = var.version
      "build_iso_path"    = var.version
      "build_version"     = var.version
    }
  }

  # provisioner "shell-local" {
  #   inline = [
  # #     # sed -i 's/oldstring/newstring/'  /path/to/vmx 
  # #     # "sed -i -e '/ethernet0.vnet = \"\"/s/.*/ethernet0.vnet = \"vmnet8\"/'  /Users/mark.west/output-vmware-iso/esxi72_x64.vmx",
  # #     # "sed -i 's/ethernet0.vnet = \"\"/ethernet0.vnet = \"vmnet8\"/'  /Users/mark.west/output-vmware-iso/esxi72_x64.vmx"
  # "sed -i -e '/ethernet0.vnet/d' /Users/mark.west/output-vmware-iso/esxi72_x64.vmx"
  #     ]
  # }

  sources = ["source.vmware-iso.autogenerated_1"]

  # post-processor "shell-local" {
  #   inline = ["'/Applications/VMware Fusion.app/Contents/Library/VMware OVF Tool/ovftool'  --X:logLevel=trivia --X:logToConsole --datastore=datastorename \"/Users/mark.west/Downloads/VMware-VCSA-all-7.0.3-19234570.iso\" \"vi://root:myp@ssw0rd fqdn ip or vc>Datacenter/host/Cluster/<Host IP or FQDN>\""]
  # }

  # post-processor "shell-local" {
  #   inline = ["'/Applications/VMware Fusion.app/Contents/Library/VMware OVF Tool/ovftool'"]

  # }
  # post-processor "manifest" {
  #   output     = "${var.save_to_dir}/packer-manifest.json"
  #   strip_path = true
  # }
}
