## Prerequisites

Before using this project, ensure you have the following prerequisites:

- An AWS account with the necessary permissions.
- AWS CLI configured on your local machine with access and secret keys.
- Terraform installed on your local machine. You can download it from [here](https://www.terraform.io/downloads.html).
- Basic familiarity with Terraform and AWS Cloud9.

## Getting Started

1. Clone this repository to your local machine.

```shell
git clone https://github.com/crispy-tk/gh-cloud9-env.git
```

2. Change into the project directory.
```shell
cd cloud9-multi-environments
```

3. Create a `terraform.tfvars` file to customize your project. You can adjust parameters such as the `instance_type`, `members_list`, and more.

4. Initialize the Terraform configuration.
```shell
terraform init
```

5. Review the Terraform execution plan to ensure everything is as expected.
```shell
terraform plan
```

6. Apply the configuration to create your Cloud9 environments.
```shell
terraform apply
```

7. Confirm the execution by typing "yes" when prompted.

8. Terraform will create the Cloud9 environments according to your specifications.
