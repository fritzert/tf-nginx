#######  resource #######

resource "aws_instance" "nginx-server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  # comandos para ami de Amazon Linux 2023
  user_data = <<-EOF
              #!/bin/bash
              sudo dnf install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              # Configuración adicional (opcional)
              echo "<h1>Hola desde Terraform!</h1>" | sudo tee /usr/share/nginx/html/index.html
              EOF

  key_name = aws_key_pair.nginx-server-ssh.key_name
  
  vpc_security_group_ids = [
	aws_security_group.nginx-server-sg.id
  ]

  tags = {
    Name        = var.server_name
    Environment = var.environment
    Owner       = "frodas@frodas.com"
    Team        = "DevOps"
    Project     = "dev"
  }
}