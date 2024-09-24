output "id" {
    value           = aws_db_instance.rds_instance.id
    description     = "The Database Instance ID"
}

output "hosted_zone_id" {
    value           = aws_db_instance.rds_instance.hosted_zone_id
    description     = "The ID of the created security group"
}

output "hostname" {
    value           = aws_db_instance.rds_instance.address
    description     = "The ID of the created security group"
}

output "port" {
    value           = aws_db_instance.rds_instance.port
    description     = "The ID of the created security group"
}

output "endpoint" {
    value           = aws_db_instance.rds_instance.endpoint
    description     = "The ID of the created security group"
}

output "rds_arn" {
    value           = aws_db_instance.rds_instance.arn
    description     = "The ID of the created security group"
}