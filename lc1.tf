resource "aws_launch_configuration" "LC1"{
	 name          = "LC1"
	image_id ="ami-0279c3b3186e54acd"
	 instance_type = "t2.micro"
	security_groups = [aws_security_group.sgforlc1.id]
	key_name =aws_key_pair.pubkeya.key_name	
}



/*create asg fusing lc1*/



resource "aws_autoscaling_group" "asg" {
	 name                      = "asg-tf"
	launch_configuration      = aws_launch_configuration.LC1.name
	vpc_zone_identifier  = [aws_subnet.s3.id, aws_subnet.s4.id]
	//user_data=file("./asg.sh*")
	desired_capacity   = "3"
        max_size           = "5"
        min_size           = "1"
	capacity_rebalance  = "true"
	load_balancers=[aws_elb.clselb.id]
 tag {
    key                 = "Key"
    value               = "Value"
    propagate_at_launch = true
  }

}



/*create topic*/
resource "aws_sns_topic" "topic1" {
	name = "topic1"
	display_name="topic1"
	fifo_topic ="false"
}

/*create subcription*/
resource "aws_sns_topic_subscription" "snssubcription" {
  topic_arn = aws_sns_topic.topic1.arn
  protocol  = "email"
  endpoint  ="sumanthg469@gmail.com"
}

/*create asg notification*/


resource "aws_autoscaling_notification" "example_notifications" {
group_names = [
    aws_autoscaling_group.asg.name
  ]
notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
topic_arn = aws_sns_topic.topic1.arn


}


/*create shude;e autoscalling*/
/*
resource resource "aws_autoscaling_schedule" "shudele"{
	autoscaling_group_name = aws_autoscaling_group.asg.name
	scheduled_action_name   = "shudele"
	min_size               = 2
 	 max_size              = 5
  	desired_capacity       = 3
	start_time             = "2021/11/23:04:18:45 UTC"
       end_time                    = "2021/11/23:04:25:45 UTC"
  recurrence="0 0 * * *"

*/























