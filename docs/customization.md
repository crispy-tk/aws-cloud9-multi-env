## Customization

To customize your Cloud9 environments, update the terraform.tfvars file with your desired configurations, including but not limited to:

* `instance_type`: The EC2 instance type to use. The default type is `t2.micro`.
* `project`: The name of your Cloud9 environment. It will be composed of the `project` parameter and a name from the `members_list` parameter.
* `members_list`: A list of usernames to associate with the Cloud9 environment. The names will be used to create new IAM Users

```
myproject-username-{randomID}
```

* `existing_user`: The ID of the subnet in which to launch the Cloud9 environment.

You can refer to the AWS Cloud9 documentation for more configuration options.
