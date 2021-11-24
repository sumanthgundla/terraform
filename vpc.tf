/*create vpc-vpc-te*/

resource "aws_vpc" "vpc-o1"{
	cidr_block="10.0.0.0/16"
	instance_tenancy="default"
	tags={
		Name="vpc-te"
		env="dev"
}
}
/*subnet1-creation*/

resource "aws_subnet" "s1"{
	availability_zone="us-east-1a"
	cidr_block ="10.0.0.0/26"
	vpc_id=aws_vpc.vpc-o1.id
	tags={
		"Name"="s1-vpc-te(public)"


}
}
resource "aws_subnet" "s2"{
	availability_zone="us-east-1b"
	cidr_block ="10.0.0.64/26"
	vpc_id=aws_vpc.vpc-o1.id
	tags={
		"Name"="s2-vpc-te(public)"


}
}
resource "aws_subnet" "s3"{
	availability_zone="us-east-1a"
	cidr_block ="10.0.0.128/26"
	vpc_id=aws_vpc.vpc-o1.id
	tags={
		"Name"="s3-vpc-te(private)"


}
}
resource "aws_subnet" "s4"{
	availability_zone="us-east-1b"
	cidr_block ="10.0.0.192/26"
	vpc_id=aws_vpc.vpc-o1.id
	tags={
		"Name"="s4-vpc-te(private)"


}
}

resource "aws_internet_gateway" "igw-te"{
	vpc_id=aws_vpc.vpc-o1.id
	tags={
	Name="igw-te"
}

}
resource "aws_route_table" "rt1_public"{
	vpc_id=aws_vpc.vpc-o1.id
	route{
        	cidr_block = "0.0.0.0/0"
   		gateway_id = aws_internet_gateway.igw-te.id
}
	tags={
		Name= "rt1(public)-te"
}
}
resource "aws_route_table" "rt2_private"{
	vpc_id=aws_vpc.vpc-o1.id
	route{
        	cidr_block = "0.0.0.0/0"
   		gateway_id = aws_nat_gateway.nat.id
}
	
	tags={
		Name= "rt2(private)-te"
}
}
/*rt1(public)-te--association to sn1*/

resource "aws_route_table_association" "ass1-s1"{
	subnet_id=aws_subnet.s1.id
	route_table_id=aws_route_table.rt1_public.id
}
/*rt1(public)-te--association to sn2*/

resource "aws_route_table_association" "ass1-s2"{
	subnet_id=aws_subnet.s2.id
	route_table_id=aws_route_table.rt1_public.id
}
/*rt1(public)-te--association to sn3*/

resource "aws_route_table_association" "ass3-s3"{
	subnet_id=aws_subnet.s3.id
	route_table_id=aws_route_table.rt2_private.id
}
/*rt1(public)-te--association to sn4*/

resource "aws_route_table_association" "ass3-s4"{
	subnet_id=aws_subnet.s4.id
	route_table_id=aws_route_table.rt2_private.id
}
resource "aws_eip" "eip"{
	tags={
	 Name="eip"
}
	
}

resource "aws_nat_gateway" "nat"{
	allocation_id=aws_eip.eip.id
	subnet_id=aws_subnet.s1.id
	connectivity_type="public"
	tags={
		Name="nat"
}
}
resource "aws_security_group" "sgte"{
	description="sgte"
	name="sgte"
	vpc_id=aws_vpc.vpc-o1.id
	 ingress {
    		description      = "TLS from VPC"
    		from_port        = 22
    		to_port          = 22
    		protocol         = "tcp"
    		cidr_blocks      = ["0.0.0.0/0"]
    		}

	 ingress {
    		description      = "TLS from VPC"
    		from_port        = 80
    		to_port          = 80
    		protocol         = "tcp"
    		cidr_blocks      = ["0.0.0.0/0"]
    		}

	
	 egress {
    		from_port        = 0
   		 to_port          = 0
   		 protocol         = "-1"
   		 cidr_blocks      = ["0.0.0.0/0"]
   		
  }
	tags={
		Name="sgte"
	
}
}
resource "aws_security_group" "sgteelb"{
	description="sgteelb"
	name="sgteelb"
	vpc_id=aws_vpc.vpc-o1.id
	 ingress {
    		description      = "TLS from VPC"
    		from_port        = 80
    		to_port          = 80
    		protocol         = "tcp"
    		cidr_blocks      = ["0.0.0.0/0"]
    		}
	
	 egress {
    		from_port        = 0
   		 to_port          = 0
   		 protocol         = "-1"
   		 cidr_blocks      = ["0.0.0.0/0"]
   		
  }
	tags={
		Name="sgteelb"
	
}
}
resource "aws_security_group" "sgforlc1"{
	description="sgforlc1"
	name="sgforlc1"
	vpc_id=aws_vpc.vpc-o1.id
	 ingress {
    		description      = "TLS from VPC"
    		from_port        = 80
    		to_port          = 80
    		protocol         = "tcp"
    		cidr_blocks      = ["0.0.0.0/0"]
    		}
	
	 egress {
    		from_port        = 0
   		 to_port          = 0
   		 protocol         = "-1"
   		 cidr_blocks      = ["0.0.0.0/0"]
   		
  }
	tags={
		Name="sgforlc1"
	
}
}

resource "aws_key_pair" "pubkeya"{
	key_name="key2"
	public_key=file("./a.pub")
	tags={
		Name="key2"
}

}









