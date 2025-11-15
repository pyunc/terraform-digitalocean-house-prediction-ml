terraform {
  required_version = "~> 1.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# provider "digitalocean" {
#   token = var.do_token
# }

# esse valor pode ser colocado diretamente no ambiente do cliente
# e ver esse arquivo yaml dentro do ambiente do cliente
data "digitalocean_ssh_key" "default" {
  name = "huna-notebook"
}

# vpc primeiro, depois o load balancer, depois as vms, depois o banco de dados
resource "digitalocean_vpc" "wp_net" {
  name   = "wp-network"
  region = var.region
}

# depois do vpc entra o load balancer
resource "digitalocean_loadbalancer" "wp_lb" {
  name   = "wp-lb"
  region = var.region

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 80
    protocol = "http"
    path     = "/"
  }

  vpc_uuid = digitalocean_vpc.wp_net.id

  droplet_ids = digitalocean_droplet.vm_wp[*].id
}

# depois do vpc, dps do load balancer e agora entra as droplets
resource "digitalocean_droplet" "vm_wp" {
  name     = "vm-wp-${count.index}"
  size     = var.vm_wp_size
  image    = var.vm_wp_image
  region   = var.region
  vpc_uuid = digitalocean_vpc.wp_net.id
  count    = var.vm_wp_count
  ssh_keys = [
    data.digitalocean_ssh_key.default.fingerprint
  ]
}

# outra droplet
resource "digitalocean_droplet" "vm_nfs" {
  name     = "vm-nfs"
  size     = var.vm_wp_size
  image    = var.vm_wp_image
  region   = var.region
  vpc_uuid = digitalocean_vpc.wp_net.id
  ssh_keys = [
    data.digitalocean_ssh_key.default.fingerprint
  ]
}

# outra droplet
resource "digitalocean_database_db" "wp_database" {
  cluster_id = digitalocean_database_cluster.wp_mysql.id
  name       = "wp-database"
}

# cluster para database
# outra droplet mas agora é a base de dados
resource "digitalocean_database_cluster" "wp_mysql" {
  name                 = "wp-mysql"
  engine               = "mysql"
  version              = "8"
  size                 = "db-s-1vcpu-1gb"
  region               = var.region
  node_count           = 1
  private_network_uuid = digitalocean_vpc.wp_net.id
}

resource "digitalocean_database_user" "wp_database_user" {
  cluster_id = digitalocean_database_cluster.wp_mysql.id
  name       = "wordpress"
}
