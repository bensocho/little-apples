resource "aws_vpc" "little-apples-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    name = "${var.app_name}-vpc"
  }
}

resource "aws_subnet" "public" {
  count = length(data.aws_availability_zones.available_zones.names)
  vpc_id                  = aws_vpc.little-apples-vpc.id
  cidr_block              = cidrsubnet(aws_vpc.little-apples-vpc.cidr_block, 8, count.index + 6) 
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
}

resource "aws_subnet" "private" {
  count = length(data.aws_availability_zones.available_zones.names)
  vpc_id                  = aws_vpc.little-apples-vpc.id
  cidr_block              = cidrsubnet(aws_vpc.little-apples-vpc.cidr_block, 8, count.index) 
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.little-apples-vpc.id

  tags = {
    Name = "${var.app_name}-${var.app_environment}-igw"
  }
}

resource "aws_eip" "nat" {
  vpc = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "gateway" {
  subnet_id     = aws_subnet.public[0].id
  tags = {
    name = "${var.app_name}-${var.app_environment}-nat-gateway"
  }
  allocation_id = aws_eip.nat.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.little-apples-vpc.id
  
  tags = {
    name = "${var.app_name}-${var.app_environment}-public-rt"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(data.aws_availability_zones.available_zones)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.little-apples-vpc.id
  tags = {
    name = "${var.app_name}-${var.app_environment}-private-rt"
  }
}

resource "aws_route" "nat_route" {
  count                  = length(data.aws_availability_zones.available_zones.names)
  route_table_id         = element(aws_route_table.private-rt.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gateway.id
}

resource "aws_route_table_association" "private" {
  count          = length(data.aws_availability_zones.available_zones)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private-rt.id
}

