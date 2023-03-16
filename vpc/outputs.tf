output "vpc_arn" {
    description = "The ARN of the VPC"
    value = ""
}

output "vpc_id" {
    description = "The Id of the VPC"
    value = "data.aws_vpc.test_vpc.id"
}

output "route_table_id" {
    description = "The ID of the route table"
    value = "data.aws_route_table.route_table.id"
}