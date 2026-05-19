provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "expansive_web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "m5.4xlarge"

  root_block_device {
    volume_size           = 1000
    volume_type           = "gp3"
  }
}

resource "aws_db_instance" "expansive_db" {
  allocated_storage    = 500
  engine               = "postgres"
  engine_version       = "15.4"
  instance_class       = "db.r5.4xlarge"
  username             = "admin"
  password             = "ParolaSecurizata123!"
  skip_final_snapshot  = true
}