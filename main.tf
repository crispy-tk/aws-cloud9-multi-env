#TODO create new environment for each new-user
resource "aws_cloud9_environment_ec2" "cloud9_instance" {
  instance_type = var.instance_type
  name          = "${var.project}" != "" ? "${var.project}" : "example-${random_id.env.id}"
}

data "aws_instance" "cloud9_instance_dt" {
  filter {
    name = "tag:aws:cloud9:environment"
    values = [
    aws_cloud9_environment_ec2.cloud9_instance.id]
  }
}

# Return URL to access the environment
output "cloud9_url" {
  value = "https://${var.region}.console.aws.amazon.com/cloud9/ide/${aws_cloud9_environment_ec2.cloud9_instance.id}"
}

#TODO create new temp-user and enroll them

# Add user to access the Cloud9 Environment
data "aws_iam_user" "user" {
  user_name = var.member
}

resource "aws_cloud9_environment_membership" "user_members" {
  environment_id = aws_cloud9_environment_ec2.cloud9_instance.id
  permissions    = "read-write"
  user_arn       = data.aws_iam_user.user.arn
}