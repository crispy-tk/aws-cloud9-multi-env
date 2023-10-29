#-----------------------NEW USER----------------------------------#
# Create new user to access the Cloud9 Environment
resource "aws_iam_user" "new_user" {
  for_each = toset(var.new_members)
  name     = "${each.value}"
  force_destroy = true
}

data "aws_iam_policy" "cloud9" {
  name = "AWSCloud9User"
}

# Attach policy for new members
resource "aws_iam_user_policy_attachment" "policy_attach_new" {
  for_each   = length(var.new_members) > 1 ? toset(aws_iam_user.new_user) : toset([])
  user       = aws_iam_user.new_user[each.value].name
  policy_arn = data.aws_iam_policy.cloud9.arn
}

# Create console profile
resource "aws_iam_user_login_profile" "profile" {
  for_each = length(var.new_members) > 1 ? toset(aws_iam_user.new_user) : toset([])
  user    = aws_iam_user.new_user[each.value].name
  password_reset_required = false
}

#------------------------EXISTING USER-----------------------------#
data "aws_iam_user" "existing_user" {
  for_each = toset(var.existing_members)
  user_name = each.value
}

resource "aws_iam_user_policy_attachment" "policy_attach_existing" {
  for_each   = length(var.existing_members) > 1 ? toset(data.aws_iam_user.existing_user) : toset([])
  user       = data.aws_iam_user.existing_user[each.value].user_name
  policy_arn = data.aws_iam_policy.cloud9.arn
}

#-------------------------CLOUD9 ACCESS--------------------------------#
# Enroll users to Cloud9 Environment
resource "aws_cloud9_environment_membership" "new_user_membership" {
  for_each       = length(var.new_members) > 1 ? toset(aws_iam_user.new_user) : toset(var.new_members)
  environment_id = aws_cloud9_environment_ec2.cloud9_instance[each.value].id
  permissions    = var.members_permissions
  user_arn       = aws_iam_user.new_user[each.value].arn
}

# Enroll users to Cloud9 Environment
resource "aws_cloud9_environment_membership" "existing_user_membership" {
  for_each       = length(var.existing_members) > 1 ? toset(data.aws_iam_user.existing_user) : toset(var.existing_members)
  environment_id = aws_cloud9_environment_ec2.cloud9_instance[each.value].id
  permissions    = var.members_permissions
  user_arn       = data.aws_iam_user.existing_user[each.value].arn
}

#--------------------------CLOUD9 INSTANCE-------------------------------#
locals {
  all_members = concat(var.new_members, var.existing_members)
}

resource "aws_cloud9_environment_ec2" "cloud9_instance" {
  for_each      = toset(local.all_members)
  instance_type = var.instance_type
  name          = "${var.project}" != "" ? "${var.project}-${each.value}" : "${var.project}-${each.value}-${random_id.env.id}"
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