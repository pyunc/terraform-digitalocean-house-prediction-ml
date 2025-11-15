variable "do_token" {
  type    = string
}

variable "region" {
  type    = string
  default = "nyc1"
}

variable "vm_wp_count" {
  type    = number
  default = 2
  validation {
    condition     = var.vm_wp_count > 1 && var.vm_wp_count <= 5
    error_message = "O número de VMs para WordPress deve ser entre 2 e 5."
  }
}

variable "vm_wp_image" {
  type    = string
  default = "ubuntu-22-04-x64"
  description = "Imagem padrão para as VMs do WordPress."
  validation {
    condition     = contains(["ubuntu-20-04-x64", "ubuntu-22-04-x64"], var.vm_wp_image)
    error_message = "A imagem deve ser 'ubuntu-20-04-x64' ou 'ubuntu-22-04-x64'."
  }

}

variable "vm_wp_size" {
  type    = string
  default = "s-2vcpu-2gb"
  description = "Tamanho padrão para as VMs do WordPress."
  validation {
    condition     = contains(["s-1vcpu-1gb", "s-2vcpu-2gb", "s-3vcpu-1gb"], var.vm_wp_size)
    error_message = "O tamanho deve ser 's-1vcpu-1gb', 's-2vcpu-2gb' ou 's-3vcpu-1gb'."
  }
}
