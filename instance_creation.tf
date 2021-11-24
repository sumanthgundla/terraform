/*resource "aws_instance" "I1"{
	ami="ami-0279c3b3186e54acd"
	instance_type ="t2.micro"
	associate_public_ip_address="false"
	availability_zone="us-east-1a"
	key_name =aws_key_pair.pubkeya.key_name
	user_data = <<EOF
			#!/bin/bash
			apt update -y
			apt install apache2 -y
		EOF
	
	subnet_id=aws_subnet.s3.id
	tags ={
		Name="I1-te"
	}
	 vpc_security_group_ids =[aws_security_group.sgte.id]
}

creating i2 instance in private subnet-s4

resource "aws_instance" "I2"{
	ami="ami-0279c3b3186e54acd"
	instance_type ="t2.micro"
	associate_public_ip_address="true"
	availability_zone="us-east-1a"
	key_name =aws_key_pair.pubkeya.key_name
	user_data = <<EOF
		#!/bin/bash
		sudo apt-get update 
		sudo apt install apache2 -y 
		echo this app serv > index.html

		EOF
	
	subnet_id=aws_subnet.s1.id
	tags ={
		Name="I2-te"
	}
	 vpc_security_group_ids =[aws_security_group.sgte.id]
}


resource "aws_elb_attachment" "att1" {
  elb      = aws_elb.clselb.id
  instance = aws_instance.I1.id

resource "aws_elb_attachment" "att2" {
  elb      = aws_elb.clselb.id
  instance = aws_instance.I2.id
}
*/
resource "aws_elb" "clselb"{
	name               = "clasicelb"
	//load_balancer_type otherthan clasic we can give
	subnets = [aws_subnet.s1.id,aws_subnet.s2.id]
	availability_zones = ["us-east-1b","us-east-1a"]
	//vpc_security_group_ids =[aws_security_group.sgteelb.id]
	security_groups = [aws_security_group.sgteelb.id]
	//instances=[aws_instance.I1.id,aws_instance.I2.id]
	listener {
    		instance_port     = 80
    		instance_protocol = "http"
    		lb_port           = 80
    		lb_protocol       = "http"
}
	health_check {
    		healthy_threshold   = 3
    		unhealthy_threshold = 3
    		timeout             = 5
   		target              = "HTTP:80/index.html"
    		interval            = 6
		
  }
  }

