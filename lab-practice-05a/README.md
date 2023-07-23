# Terraform CloudのCLI-driven WorkflowによるEC2デプロイ

[EC2デプロイ手順](#ec2デプロイ手順)  
- [terraform構成](#terraform構成)  
- [1. terraform実行](#1-terraform実行)  
  - [1.1. terraform cloudログイン](#11-terraform-cloudログイン)
  - [1.2. 初期化](#12-初期化)
  - [1.3. デバッグ](#13-リソース単体のデプロイを実行)
  - [1.4. 適用](#14-適用)

## terraform構成

|Directory|Module|Description|
|--|--|--|
|[aws-createVpcs](./modules/aws-createVpcs/)|module.create_vpcs|VPC/Subnet/SG作成|
|[aws-createKeyPair](./modules/aws-createKeyPair/)|module.create_keypair|キーペア作成|
|[aws-createEc2](./modules/aws-createEc2/)|module.create_instance|EC2作成|


## 1. terraform実行

<!-- ### 1.1. S3バケット作成
- 実行するterraformテンプレート配下へ移動  

(実行コマンド)
```bash
cd ./lab-practice-05/modules/aws-createBucket; ls
```
下記が出力されることを確認
```
main.tf  outputs.tf  variables.tf
``` -->

### 1.1. terraform cloudログイン
```bash
terraform login
```


### 1.2. 初期化

terraformを初期化する  
(実行コマンド)
```bash
terraform init
```
下記が出力されればok  
```bash
Initializing Terraform Cloud...
Initializing modules...

Initializing provider plugins...
- Finding latest version of hashicorp/local...
- Finding latest version of hashicorp/tls...
- Finding hashicorp/aws versions matching "4.65.0"...
- Finding latest version of hashicorp/template...
- Installing hashicorp/local v2.4.0...
- Installed hashicorp/local v2.4.0 (signed by HashiCorp)
- Installing hashicorp/tls v4.0.4...
- Installed hashicorp/tls v4.0.4 (signed by HashiCorp)
- Installing hashicorp/aws v4.65.0...
- Installed hashicorp/aws v4.65.0 (signed by HashiCorp)
- Installing hashicorp/template v2.2.0...
- Installed hashicorp/template v2.2.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform Cloud has been successfully initialized!

You may now begin working with Terraform Cloud. Try running "terraform plan" to
see any changes that are required for your infrastructure.

If you ever set or change modules or Terraform Settings, run "terraform init"
again to reinitialize your working directory.
```

### 1.3. デバッグ

(実行コマンド)
```bash
terraform plan -target=module.create_vpcs
```

下記が出力されることを確認
```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

...(中略)
 Warning: Resource targeting is in effect
│ 
│ You are creating a plan with the -target option, which means that the result of this plan may not represent all of the changes requested by the current configuration.
│ 
│ The -target option is not for routine use, and is provided only for exceptional situations such as recovering from errors or mistakes, or when Terraform specifically suggests to use it as part of an error message.
╵

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

### 1.4. 適用

(実行コマンド)
```bash
terraform apply -target=module.create_vpcs
```

下記が出力される

```
...(中略)
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 
```

yesと入力してエンター押す

```
  Enter a value: yes

│ Warning: Applied changes may be incomplete
│ 
│ The plan was created with the -target option in effect, so some changes requested in the configuration may have been ignored and the output values may not be fully updated. Run the following command to verify that
│ no other changes are pending:
│     terraform plan
│ 
│ Note that the -target option is not suitable for routine use, and is provided only for exceptional situations such as recovering from errors or mistakes, or when Terraform specifically suggests to use it as part of
│ an error message.
╵

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

(以下略...)
```

続いて、-targetオプションをcreate_keypair, create_instanceに変えて、手順1.3を繰り返し実行する