resource "aws_cloud9_environment_ec2" "cloud9_instance" {
  for_each      = toset(var.members_list)
  instance_type = var.instance_type
  name          = "${var.project}" != "" ? "${var.project}-${each.value}" : "example-${each.value}-${random_id.env.id}"
}

# Create new user to access the Cloud9 Environment
resource "aws_iam_user" "user" {
  for_each = toset(var.members_list)
  name     = "${each.value}"
  force_destroy = true
}

data "aws_iam_policy" "cloud9" {
  name = "AWSCloud9User"
}

resource "aws_iam_user_policy_attachment" "policy_attach" {
  for_each   = toset(var.members_list)
  user       = aws_iam_user.user[each.value].name
  policy_arn = data.aws_iam_policy.cloud9.arn
}

# Create console profile
resource "aws_iam_user_login_profile" "profile" {
  for_each = toset(var.members_list)
  user    = aws_iam_user.user[each.value].name
  password_reset_required = false
}

# Enroll users to Cloud9 Environment
resource "aws_cloud9_environment_membership" "user_list" {
  for_each       = toset(var.members_list)
  environment_id = aws_cloud9_environment_ec2.cloud9_instance[each.value].id
  permissions    = "read-write"
  user_arn       = aws_iam_user.user[each.value].arn
}

output "cloud9_url" {
  description = "Return URL to access the environment"
  value = {
    for k, v in aws_cloud9_environment_ec2.cloud9_instance : k =>
    "https://${var.region}.console.aws.amazon.com/cloud9/ide/${v.id}"
  }
}

output "password" {
  description = "Return user(s) profile(s) password(s) for console access."
  value = {
    for k, v in aws_iam_user_login_profile.profile : k => v.password
  }
  sensitive = true
}