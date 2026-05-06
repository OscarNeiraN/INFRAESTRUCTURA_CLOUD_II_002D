resource "aws_vpc" "main" {
  count = var.enable_network ? 1 : 0
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = var.project_name }
}

resource "aws_subnet" "public" {
  for_each = var.enable_network ? var.subnets_config : {}
  vpc_id                  = aws_vpc.main[0].id
  cidr_block              = cidrsubnet(aws_vpc.main[0].cidr_block, 8, each.value.net_num)
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags = { Name = each.key }
}

resource "aws_internet_gateway" "main" {
  count  = var.enable_network ? 1 : 0
  vpc_id = aws_vpc.main[0].id
}

resource "aws_route_table" "main" {
  count  = var.enable_network ? 1 : 0
  vpc_id = aws_vpc.main[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main[0].id
  }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.main[0].id
}