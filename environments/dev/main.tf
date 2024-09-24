
# module "vpc"{
#   source                          = "../../modules/VPC"
#   vpc_name                        = var.vpc_name
#   vpc_cidr_block                  = var.vpc_cidr_block
#   vpc_env                         = var.vpc_env
#   subnet_cidr_blocks              = {
#     public_subnet1                = {
#       subnet_cidr_block           = var.subnet1_cidr_block
#       availability_zone           = var.availability_zone_1
#       ipv6_address                = false
#       ip4_address                 = true
#       sub_name                    = var.subnet1
#     }
#     public_subnet2                = {
#       subnet_cidr_block           = var.subnet2_cidr_block
#       availability_zone           = var.availability_zone_2
#       ipv6_address                = false
#       ip4_address                 = true
#       sub_name                    = var.subnet2
#     }
#     public_subnet3                = {
#       subnet_cidr_block           = var.subnet3_cidr_block
#       availability_zone           = var.availability_zone_3
#       ipv6_address                = false
#       ip4_address                 = true
#       sub_name                    = var.subnet3
#     }
#     private_subnet1               = {
#       subnet_cidr_block           = var.subnet4_cidr_block
#       availability_zone           = var.availability_zone_1
#       ipv6_address                = false
#       ip4_address                 = false
#       sub_name                    = var.subnet4
#     }
#     private_subnet2               = {
#       subnet_cidr_block           = var.subnet5_cidr_block
#       availability_zone           = var.availability_zone_2
#       ipv6_address                = false
#       ip4_address                 = false
#       sub_name                    = var.subnet5
#     }
#     private_subnet3               = {
#       subnet_cidr_block           = var.subnet6_cidr_block
#       availability_zone           = var.availability_zone_3
#       ipv6_address                = false
#       ip4_address                 = false
#       sub_name                    = var.subnet6
#     }
#   }
#   db_subnet_group_name            = var.db_subnet_group_name
# }

 module "key-pair" {
  source                          = "../../modules/key-pair"
  key_pair_name                   = var.key_pair_name
}