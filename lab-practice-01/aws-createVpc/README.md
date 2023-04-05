# VPC作成手順

## 1. terraform実行
実行するterraformテンプレート配下へ移動  

(実行例)
```bash
cd ./lab-practice-01/aws-createVpc; ls
```
下記が出力されることを確認
```
main.tf
```
### 1.1. 初期化

以下コマンドでterraformを初期化する
```bash
terraform init
```
下記が出力されればok  
```bash
...(中略)
Terraform has been successfully initialized!
You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.
If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
### 1.2. デバッグ
下記コマンドを実行
```bash
terraform plan
```
下記が出力されればok 
```bash
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_vpc.example will be created
  + resource "aws_vpc" "example" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_classiclink                   = (known after apply)
      + enable_classiclink_dns_support       = (known after apply)
      + enable_dns_hostnames                 = (known after apply)
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags_all                             = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```
### 1.3. 適用
下記コマンドを実行
```bash
terraform apply
```
下記が出力される
```bash
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_vpc.example will be created
  + resource "aws_vpc" "example" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_classiclink                   = (known after apply)
      + enable_classiclink_dns_support       = (known after apply)
      + enable_dns_hostnames                 = (known after apply)
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags_all                             = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 
```
```yes```と入力してエンター押す  
問題なくデプロイ完了すると下記が出力される  
```bash
aws_vpc.example: Creating...
aws_vpc.example: Creation complete after 3s [id=vpc-xxxxxxxxxxxx]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
デプロイした際のリソースの変数は、terraform.tfstateに記録される  
※```terraform apply```時にエラーが出力された場合、該当のtfファイルを編集し、terraform.tfstateを削除orリネームした上で再度、```terraform init```から実施すること
### 1.4. 切り戻し
削除したいAWSリソースの内容を確認する
```bash
terraform plan -destroy
```
下記が出力される
```
aws_vpc.example: Refreshing state... [id=vpc-xxxxxxxxxxxx]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_vpc.example will be destroyed
  - resource "aws_vpc" "example" {
      - arn                                  = "arn:aws:ec2:ap-northeast-1:xxxxxxxxxxxx:vpc/vpc-xxxxxxxxxxxx" -> null
      - assign_generated_ipv6_cidr_block     = false -> null
      - cidr_block                           = "10.0.0.0/16" -> null
      - default_network_acl_id               = "acl-xxxxxxxxxxxx" -> null
      - default_route_table_id               = "rtb-xxxxxxxxxxxx" -> null
      - default_security_group_id            = "sg-xxxxxxxxxxxx" -> null
      - dhcp_options_id                      = "dopt-xxxxxx" -> null
      - enable_classiclink                   = false -> null
      - enable_classiclink_dns_support       = false -> null
      - enable_dns_hostnames                 = false -> null
      - enable_dns_support                   = true -> null
      - enable_network_address_usage_metrics = false -> null
      - id                                   = "vpc-xxxxxxxxxxxx" -> null
      - instance_tenancy                     = "default" -> null
      - ipv6_netmask_length                  = 0 -> null
      - main_route_table_id                  = "rtb-xxxxxxxxxxxx" -> null
      - owner_id                             = "xxxxxxxxxxxx" -> null
      - tags                                 = {} -> null
      - tags_all                             = {} -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```
AWSリソースの削除
```bash
terraform destroy
```
下記が出力される

```
aws_vpc.example: Refreshing state... [id=vpc-xxxxxxxxxxxx]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_vpc.example will be destroyed
  - resource "aws_vpc" "example" {
      - arn                                  = "arn:aws:ec2:ap-northeast-1:xxxxxxxxxxxx:vpc/vpc-xxxxxxxxxxxx" -> null
      - assign_generated_ipv6_cidr_block     = false -> null
      - cidr_block                           = "10.0.0.0/16" -> null
      - default_network_acl_id               = "acl-xxxxxxxxxxxx" -> null
      - default_route_table_id               = "rtb-xxxxxxxxxxxx" -> null
      - default_security_group_id            = "sg-xxxxxxxxxxxx" -> null
      - dhcp_options_id                      = "dopt-xxxxxx" -> null
      - enable_classiclink                   = false -> null
      - enable_classiclink_dns_support       = false -> null
      - enable_dns_hostnames                 = false -> null
      - enable_dns_support                   = true -> null
      - enable_network_address_usage_metrics = false -> null
      - id                                   = "vpc-xxxxxxxxxxxx" -> null
      - instance_tenancy                     = "default" -> null
      - ipv6_netmask_length                  = 0 -> null
      - main_route_table_id                  = "rtb-xxxxxxxxxxxx" -> null
      - owner_id                             = "xxxxxxxxxxxx" -> null
      - tags                                 = {} -> null
      - tags_all                             = {} -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: 
  ```
  
  ```yes```と入力してエンター押す 
  ```
  aws_vpc.example: Destroying... [id=vpc-xxxxxxxxxxxx]
aws_vpc.example: Destruction complete after 1s

Destroy complete! Resources: 1 destroyed.
```
AWS環境にデプロイされたVPCが削除され、terraform.tfstateの変数が空になっていることを確認
