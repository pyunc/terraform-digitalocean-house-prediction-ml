terraform {
  required_version = ">= 1.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "default" {
  name = "huna-notebook"
}

module "do_wp_stack" {
  source = "./modules/do-wp-stack"

  do_token     = var.do_token
  region       = var.region
  vm_wp_count  = var.vm_wp_count
  vm_wp_image  = "ubuntu-22-04-x64"
  vm_wp_size   = "s-2vcpu-2gb"
}