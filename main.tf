provider "aws" {
  region = var.region
}

# Gọi Module Networking
module "networking" {
  source              = "./modules/networking"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  az                  = "${var.region}a"
}

# Gọi Module Security
module "security" {
  source = "./modules/security"
  vpc_id = module.networking.vpc_id
  my_ip  = var.my_ip_address
}

# Gọi Module Compute
module "compute" {
  source            = "./modules/compute"
  ami_id            = "ami-0eeab253db7e765a9" 
  instance_type     = "t3.micro"
  public_subnet_id  = module.networking.public_subnet_id
  private_subnet_id = module.networking.private_subnet_id
  public_sg_id      = module.security.public_sg_id
  private_sg_id     = module.security.private_sg_id
  key_name          = var.key_pair_name
}
