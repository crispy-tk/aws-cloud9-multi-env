resource "aws_cloud9_environment_ec2" "cloud9_instance" {
  for_each = toset(var.members_list)
  instance_type = var.instance_type
  name          = "${var.project}" != "" ? "${var.project}-${each.value}" : "example-${each.value}-${random_id.env.id}"
}

# Create new user to access the Cloud9 Environment
resource "aws_iam_user" "user" {
  for_each = toset(var.members_list)
  name = "user-${each.value}"
}

# Add existing user to access the Cloud9 Environment
data "aws_iam_user" "user" {
  user_name = var.existing_user
}

# Enroll users to Cloud9 Environment
resource "aws_cloud9_environment_membership" "user_list" {
  for_each = toset(var.members_list)
  environment_id = aws_cloud9_environment_ec2.cloud9_instance[each.value].id
  permissions    = "read-write"
  user_arn = aws_iam_user.user[each.value].arn
}

resource "aws_cloud9_environment_membership" "user_members" {
  for_each = toset(var.members_list)
  environment_id = aws_cloud9_environment_ec2.cloud9_instance[each.value].id
  permissions    = "read-write"
  user_arn       = data.aws_iam_user.user.arn
}

# Return URL to access the environment
output "cloud9_url" {
  value = {
    for k, v in aws_cloud9_environment_ec2.cloud9_instance : k => 
      "https://${var.region}.console.aws.amazon.com/cloud9/ide/${v.id}"
  }
}