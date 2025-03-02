
####### modulos #######

module "nginx_server_dev" {
    source = "./nginx_server_module"

    ami_id           = "ami-00a929b66ed6e0de6"
    instance_type    = "t2.micro"
    server_name      = "nginx-server-dev"
    environment      = "dev"
}


#######  output #######

output "nginx_dev_ip" {
  description = "Dirección IP pública de la instancia EC2"
  value       = module.nginx_server_dev.server_public_ip
}

output "nginx_dev_dns" {
  description = "DNS público de la instancia EC2"
  value       = module.nginx_server_dev.server_public_dns
}

