# EC2デプロイ手順

[EC2デプロイ手順](#ec2デプロイ手順)  
- [terraform構成](#terraform構成)  
- [1. terraform実行](#1-terraform実行)  
  - [1.1. 初期化](#11-初期化)  
  - [1.2. リソース一括デプロイする場合](#12-リソース一括デプロイする場合)   
  - [1.3. リソース単体のデプロイをする場合](#13-リソース単体のデプロイをする場合)

## terraform構成

|Directory|Module|Description|
|--|--|--|
|[aws-createVpcs](./modules/aws-createVpcs/)|module.create_vpcs|VPC/Subnet/SG作成|
|[aws-createKeyPair](./modules/aws-createKeyPair/)|module.create_keypair|キーペア作成|
|[aws-createEc2](./modules/aws-createEc2/)|module.create_instance|EC2作成|


## 1. terraform実行
実行するterraformテンプレート配下へ移動  
(実行コマンド)
```bash
cd ./lab-practice-02; ls
```
下記が出力されることを確認
```
main.tf  modules  README.md
```

### 1.1. 初期化

terraformを初期化する  
(実行コマンド)
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
### 1.2. リソース一括デプロイする場合
1.2.1. デバッグ  

(実行コマンド)
```bash
terraform plan
```
下記が出力されればok 

```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:
...(中略)
Plan: 8 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

1.2.2. 適用  
(実行コマンド)
```bash
terraform apply
```
下記が出力されればok 
```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

...(中略)
Plan: 8 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 
```

```yes```と入力してエンター押す
```
  Enter a value: yes
module.create_keypair.tls_private_key.keygen: Creating...
module.create_vpcs.aws_vpc.test: Creating...
module.create_vpcs.aws_vpc.test: Creation complete after 2s [id=vpc-xxxxxxxxxxxx]
module.create_vpcs.aws_subnet.subnet_apne1c: Creating...
module.create_vpcs.aws_security_group.allow_traffic: Creating...
module.create_keypair.tls_private_key.keygen: Creation complete after 4s [id=xxxxxxxxxxxx]
module.create_keypair.aws_key_pair.key_pair: Creating...
module.create_keypair.local_file.public_key_openssh: Creating...
module.create_keypair.local_file.private_key_pem: Creating...
module.create_keypair.local_file.public_key_openssh: Provisioning with 'local-exec'...
module.create_keypair.local_file.public_key_openssh (local-exec): Executing: ["/bin/sh" "-c" "chmod 600 ./.key_pair/labtest-keypair-01.id_rsa.pub"]
module.create_keypair.local_file.private_key_pem: Provisioning with 'local-exec'...
module.create_keypair.local_file.private_key_pem (local-exec): Executing: ["/bin/sh" "-c" "chmod 600 ./.key_pair/labtest-keypair-01.id_rsa"]
module.create_keypair.local_file.private_key_pem: Creation complete after 0s [id=xxxxxxxxxxxx]
module.create_keypair.local_file.public_key_openssh: Creation complete after 0s [id=xxxxxxxxxxxx]
module.create_keypair.aws_key_pair.key_pair: Creation complete after 0s [id=labtest-keypair-01]
module.create_vpcs.aws_subnet.subnet_apne1c: Creation complete after 1s [id=subnet-xxxxxxxxxxxx]
module.create_vpcs.aws_security_group.allow_traffic: Creation complete after 4s [id=sg-xxxxxxxxxxxx]
module.create_instance.data.aws_security_groups.selected: Reading...
module.create_instance.data.aws_ssm_parameter.amzn2_ami: Reading...
module.create_instance.data.aws_key_pair.selected: Reading...
module.create_instance.data.aws_subnet.selected: Reading...
module.create_instance.data.aws_key_pair.selected: Read complete after 0s [id=key-xxxxxxxxxxxx]
module.create_instance.data.aws_ssm_parameter.amzn2_ami: Read complete after 0s [id=/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2]
module.create_instance.data.aws_security_groups.selected: Read complete after 0s [id=ap-northeast-1]
module.create_instance.data.aws_subnet.selected: Read complete after 0s [id=subnet-xxxxxxxxxxxx]
module.create_instance.aws_instance.demo: Creating...
module.create_instance.aws_instance.demo: Still creating... [10s elapsed]
module.create_instance.aws_instance.demo: Still creating... [20s elapsed]
module.create_instance.aws_instance.demo: Still creating... [30s elapsed]
module.create_instance.aws_instance.demo: Creation complete after 34s [id=i-xxxxxxxxxxxx]

Apply complete! Resources: 8 added, 0 changed, 0 destroyed.
```

### 1.3. リソース単体のデプロイをする場合
1.3.1. デバッグ  
単一のモジュールを実行する  

(実行コマンド)
```bash
terraform plan -target=module.create_vpcs
```
下記が出力されればok 

```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.create_vpcs.aws_security_group.allow_traffic will be created
...(中略)
Plan: 3 to add, 0 to change, 0 to destroy.
╷
│ Warning: Resource targeting is in effect
│ 
│ You are creating a plan with the -target option, which means that the result of this plan may not represent all of the changes requested by the current configuration.
│ 
│ The -target option is not for routine use, and is provided only for exceptional situations such as recovering from errors or mistakes, or when Terraform specifically suggests to
│ use it as part of an error message.
╵

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

1.3.2 適用  
(実行コマンド)
```bash
terraform apply -target=module.create_vpcs
```
下記が出力されればok 
```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.create_vpcs.aws_security_group.allow_traffic will be created
  + resource "aws_security_group" "allow_traffic" {
      + arn                    = (known after apply)
      + description            = "Allow SSH and TLS inbound traffic"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "172.32.0.0/16",
                ]
              + description      = "SSH from VPC"
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
            },
...(中略)
Plan: 3 to add, 0 to change, 0 to destroy.
╷
│ Warning: Resource targeting is in effect
│ 
│ You are creating a plan with the -target option, which means that the result of this plan may not represent all of the changes requested by the current configuration.
│ 
│ The -target option is not for routine use, and is provided only for exceptional situations such as recovering from errors or mistakes, or when Terraform specifically suggests to
│ use it as part of an error message.
╵

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 
```

```yes```と入力してエンター押す
```
  Enter a value: yes
module.create_vpcs.aws_vpc.test: Creating...
module.create_vpcs.aws_vpc.test: Creation complete after 2s 
...(中略)
╷
│ Warning: Applied changes may be incomplete
│ 
│ The plan was created with the -target option in effect, so some changes requested in the configuration may have been ignored and the output values may not be fully updated. Run
│ the following command to verify that no other changes are pending:
│     terraform plan
│ 
│ Note that the -target option is not suitable for routine use, and is provided only for exceptional situations such as recovering from errors or mistakes, or when Terraform
│ specifically suggests to use it as part of an error message.
╵

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```