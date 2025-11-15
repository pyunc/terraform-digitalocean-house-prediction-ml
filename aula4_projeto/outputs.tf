
output "lb_ip" {
  value = module.do_wp_stack.lb_ip
}

output "database_username" {
  value = module.do_wp_stack.database_username
}


output "database_password" {
  value     = module.do_wp_stack.database_password
  sensitive = true
}


output "vm_wp_ip" {
  value = module.do_wp_stack.vm_wp_ip
}

output "nfs_ip" {
  value = module.do_wp_stack.nfs_ip
}

output "database_host" {
  value = module.do_wp_stack.database_host
}