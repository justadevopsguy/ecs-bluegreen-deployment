# Create a route table for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.production.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_igw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

# Associate the public subnets with the public route table
resource "aws_route_table_association" "public_subnet_association" {
  count = 3
  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a route table for the private subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.production.id
  tags = {
    Name = "private-route-table"
  }
}

# Associate the private subnets with the private route table
resource "aws_route_table_association" "private_subnet_association" {
  count = 3
  subnet_id = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

# Route for NAT Gateway
resource "aws_route" "natgw_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ecs_nat_1.id
  depends_on = [
    aws_nat_gateway.ecs_nat_1
  ]
}