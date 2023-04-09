# Create the web/public subnets
resource "aws_subnet" "public_subnet" {
  count = 3
  vpc_id = aws_vpc.production.id
  cidr_block = "10.20.${count.index}.0/24"
  availability_zone = element(local.availability_zones, count.index)

  tags = merge(local.default_tags, {
    Name = "public-subnet-${count.index}"
  })
}

# Create the application subnets
resource "aws_subnet" "private_subnet" {
  count = 3
  vpc_id = aws_vpc.production.id
  cidr_block = "10.20.${count.index + 3}.0/24"
  availability_zone = element(local.availability_zones, count.index)
  tags = merge(local.default_tags, {
    Name = "private-subnet-${count.index}"
  })
}

# Create the database subnets
resource "aws_subnet" "db_subnet" {
  count = 3
  vpc_id = aws_vpc.production.id
  cidr_block = "10.20.${count.index + 6}.0/24"
  availability_zone = element(local.availability_zones, count.index)
  tags = merge(local.default_tags, {
    Name = "database-subnet-${count.index}"
  })
}