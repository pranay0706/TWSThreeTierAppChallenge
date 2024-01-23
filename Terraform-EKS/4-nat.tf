resource "aws_eip" "eip" {
    vpc = true

    tags = {
        Name = "eks-eip"
    }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-us-east-1a.id

  tags = {
    Name = "eks-nat-gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}