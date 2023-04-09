# Create the internet gateway
resource "aws_internet_gateway" "ecs_igw" {
  vpc_id = aws_vpc.production.id
  tags = merge(local.default_tags, {
    Name = "ecs-igw"
  })

  depends_on = [
    aws_vpc.production,
  ]
}

resource "aws_nat_gateway" "ecs_nat_1" {
  allocation_id = aws_eip.ecs_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags = merge({
    Name = "${local.environment}-application-nat"
    },
    local.default_tags,
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [
    aws_internet_gateway.ecs_igw,
    aws_eip.ecs_eip,
  ]
}

resource "aws_eip" "ecs_eip" {
  vpc = true
  tags = merge({
    Name = "${local.environment}-application-eip"
    },
    local.default_tags,
  )
}