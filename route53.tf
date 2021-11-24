/*create hosted zone for abc.com*/

resource "aws_route53_zone" "zone1" {
	name = "sumanth.com" //domain-name
	
	 vpc {
	vpc_id=aws_vpc.vpc-o1.id
	vpc_region="us-east-1"
  }

	tags={
		Name="hs1"
}
}

/*create a record set for alias of clasic load balancer*/

resource "aws_route53_record" "record1" {
	
	name="sumanth.com"
	type ="A"
	zone_id  = aws_route53_zone.zone1.zone_id
	  alias {
 		name                   = aws_elb.clselb.dns_name
		zone_id                = aws_elb.clselb.zone_id
		evaluate_target_health = true
  
}
}







