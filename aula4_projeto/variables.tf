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