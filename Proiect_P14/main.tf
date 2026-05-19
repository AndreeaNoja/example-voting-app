provider "aws" {
  region = "us-east-1"
}
# First cost-saving measure
resource "aws_instance" "web_server_scump" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"          

  root_block_device {
    volume_size           = 20          
    volume_type           = "gp3"
  }
}

# Second cost-saving measure
resource "aws_db_instance" "baza_date_scumpa" {
  allocated_storage    = 20               
  engine               = "postgres"
  engine_version       = "15.4"
  instance_class       = "db.t3.micro"    
  username             = "admin"
  password             = "ParolaSecurizata123!"
  skip_final_snapshot  = true
}