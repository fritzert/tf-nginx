####### ssh #######

# COMO BUENA PRACTICA CADA INSTANCIA DEBE TENER SU PROPIA LLAVE SSH
# ssh-keygen -t rsa -b 2048 -f "nginx-server-dev.key"

resource "aws_key_pair" "nginx-server-ssh" {
  key_name   = "${var.server_name}-ssh"
  public_key = file("${var.server_name}.key.pub")

  tags = {
    Name        = "${var.server_name}-ssh"
    Environment = "${var.environment}"
    Owner       = "frodas@frodas.com"
    Team        = "DevOps"
    Project     = "dev"
  }
}