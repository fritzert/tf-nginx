# BUENAS PRÁCTICAS
- Gestionar en varios archivos el código, puede ir todo en un archivo único pero lo ideal es separarlo en archivos
- Versionar siempre el código
- Implementar variables
- Implementar Módulos
<br />
<br />


# VARIABLES - tfvars
Por defecto al ejecutar apply, terraform hace la ejecución buscando en el directorio actual el archivo terraform.tfvars
```bash
terraform apply
terraform apply -var-file=terraform.tfvars
```

Si el archivo tiene otro nombre se le indica
```bash
terraform apply -var-file=dev.tfvars
```

Si no se usa el .tfvars se debe eliminar para no ver los warning en el apply

Si queremos aplicar y aprobar sin necesidad de indicar yes, usamos approve
```bash
terraform apply -var-file=qa.tfvars --auto-approve
```
<br />
<br />


# MODULOS
Los módulos en terraform son una forma de encapsular y reutilizar bloques de configuración, en este caso se creó un  módulo para crear un servidor nginx en aws, con una llave ssh y un grupo de seguridad que permite el acceso a través del puerto 80 y 22.

El módulo se encuentra en la carpeta ``nginx_server_module``, creación de recursos con módulos, puede ser uno o varios módulos.
```bash
# no debe existir ningun recurso
terraform destroy

# por cada módulo que se quiera crear se debe ejecutar
terraform init
```

```python
# CREANDO UNA INSTANCIA PARA DEV
module "nginx_server_dev" {
    source = "./nginx_server_module"

    ami_id           = "ami-0440d3b780d96b29d"
    instance_type    = "t3.medium"
    server_name      = "nginx-server-dev"
    environment      = "dev"
}

# CREANDO UNA INSTANCIA PARA QA
module "nginx_server_qa" {
    source = "./nginx_server_module"

    ami_id           = "ami-0440d3b780d96b29d"
    instance_type    = "t3.small"
    server_name      = "nginx-server-qa"
    environment      = "qa"
}
```
<br />
<br />


# ESTADO DE TERRAFORM
El archivo terraform.tfstate es un archivo que contiene el estado actual de la infraestructura y es manejada por terraform, no debe alojarse en la pc local

Se utiliza para realizar un seguimiento de los recursos creados y sus propiedades, se genera cuando se ejecuta:
```bash
terraform apply
```

Creamos un bucket en la consola de aws (nombre: demo-terraform-123) y ponemos los datos en el archivo main.tf, la key es la ruta y nombre del archivo
```python
terraform {
  backend "s3" {
    bucket  = "demo-terraform-123"
    # nombre_carpeta/nombre_archivo
    key     = "demo-terraform/terraform.tfstate"
    region  = "us-east-1"
  }
}
```

Configurar backend con el proveedor (aws), detecta nuestro terraform backend y pregunta si queremos migrar nuestro archivo de estado al s3, indicamos que si
```bash
terraform init
```

Revisamos el bucket s3 y veremos el archivo
```bash
demo_terraform/
    terraform.tfstate
```
<br />
<br />


# IMPORTAR
Importar recursos ya existentes para gestionarlos desde Terraform

Creamos una instancia manualmente y obtenemos su id, creamos un archivo main.tf con lo siguiente
```terraform
resource "aws_instance" "server-web" {
}
```

Importarmos el tipo de instancia (aws_instance que es un EC2), el nombre que tendra (server-web) y el id de la instancia, ejecutamos:
```bash
terraform import aws_instance.server-web i-0xxxid_instance
```

Luego si queremos ver el estado
```bash
terraform state show aws_instance.server-web
```

Agregar tags a la instancia creada, 
```python
# aws_instance.server-web:
resource "aws_instance" "server-web" {
    ami             = "ami-0440d3b780d96b29d"
    instance_type   = "t2.medium"
    # tags agregados
    tags = {
        Name        = "server-web"
        Environment = "test"
        Owner       = "frodas@frodas.com"
        Team        = "DevOps"
        Project     = "Demo"
    }
    vpc_security_group_ids               = [
        "sg-0d5b0d5e416f094c1",
    ]
}
```
```bash
# verificar cambios
terraform plan

# aplicar cambios y aprobarlos
terraform apply --auto-approve
```
