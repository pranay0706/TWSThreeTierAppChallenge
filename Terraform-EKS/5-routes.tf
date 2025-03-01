resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route = [ 
    {
        cidr_block = "0.0.0.0/0",
        nat_gateway_id = aws_nat_gateway.nat.id
    }
   ]

   tags = {
    Name = "private_rt"
   }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route = [ 
    {
        cidr_block = "0.0.0.0/0",
        gateway_id = aws_internet_gateway.igw.id
    }
   ]

   tags = {
    Name = "public_rt"
   }
}

resource "aws_route_table_association" "private-us-east-1a" {
  subnet_id = aws_subnet.private-us-east-1a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private-us-east-1b" {
  subnet_id = aws_subnet.private-us-east-1b.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "public-us-east-1a" {
  subnet_id = aws_subnet.public-us-east-1a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public-us-east-1b" {
  subnet_id = aws_subnet.public-us-east-1b.id
  route_table_id = aws_route_table.public_rt.id
}

