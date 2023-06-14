# VPCフローログ設定手順

[VPCフローログ設定手順](#vpcフローログ設定手順)  
- [terraform構成](#terraform構成)
- [1. 事前準備](#1-事前準備)  
  - [1.1. 前提条件](#11-前提条件)  
  - [1.2. クロスアカウントアクセス用IAMロール(スイッチロール)の作成](#12-クロスアカウントアクセス用iamロールスイッチロールの作成)   
  - [1.3. スイッチロールの確認](#13-スイッチロールの確認)
- [2. terraform実行](#2-terraform実行)
  - [2.1. 初期化](#21-初期化)
  - [2.2. リソース一括デプロイする場合](#22-リソース一括デプロイする場合)
  - [2.3. リソース単体のデプロイをする場合](#23-リソース単体のデプロイをする場合)


## terraform構成

|Directory|Module|Description|
|--|--|--|
|[createS3bucket](./modules/createS3bucket/)|module.create_bucket|S3バケット及びバケットポリシー作成|
|[createVpc](./modules/createVpc/)|module.create_vpcs|VPC CIDR作成及びVPCフローログ設定|


## 1. 事前準備
### 1.1. 前提条件
- 複数のAWSアカウントが同じOrganizationに所属し、いずれもAWSマネジメントコンソールへのアクセスが可能であること
- クロスアカウントアクセスのためのスイッチロールを作成していること(※作成していない場合、下記手順1.2を実施する)  
- CloudFormation実行権限を持っていること(※下記手順1.2を実施する場合に必要)

### 1.2. クロスアカウントアクセス用IAMロール(スイッチロール)の作成
- アクセス先(スイッチ先)アカウントへサインインする
- 「CloudFormation」>「スタック」>「スタックの作成」>「新しいリソースを使用(標準)」を選択
- 「テンプレートの準備完了」と「テンプレートファイルのアップロード」のラジオボタンがチェックされていることを確認し、[SwitchRoleWithPowerUser.yml](./SwitchRoleWithPowerUser.yml)を選択して、「次へ」を選択 

- スタック名に任意の名前を入力し、CrossAccountRoleName変数に任意の文字列、SourceAccountId変数にアクセス元アカウントIDを入力して「次へ」を選択  

(スタック名の例)
```
CustomManaged-IAM-SwitchRoleForPowerUser-001
```
- 「スタックオプションの設定」画面では何も入力せず、「次へ」を選択
- デプロイ内容を確認し、末尾の「AWS CloudFormation によって IAM リソースがカスタム名で作成される場合があることを承認します。」のチェックボックスを選択して、「送信」を選択
- ステータスがCREATE_COMPLETEになったことを確認する
- 「IAM」サービスのページへアクセスし、「ロール」を選択して「SwitchRoleWithPowerUserAccess」が存在していることを確認

### 1.3. スイッチロールの確認
- アクセス元アカウントにIAMユーザでサインインする
- ダッシュボードページの一番右上の「@ユーザ名」をクリックし、「ロールの切り替え」を選択
- 「アカウント」にアクセス先(スイッチ先)アカウントIDを入力
- 「ロール」に上記で作成したロール名を入力  

(上記例の場合のロール名)
```
SwitchRoleWithPowerUserAccess
```
- 表示名に任意の文字を入力する  

(入力例)
```
<スイッチ先アカウント名>-PowerUserAccess
```

- 「ロールの切り替え」を選択
- スイッチ先のアカウントのダッシュボードへ遷移し、一番右上に上記で入力した「表示名」が反映されていることを確認





## 2. terraform実行
実行するterraformテンプレート配下へ移動  
(実行コマンド)
```bash
cd ./lab-practice-03; ls
```
下記が出力されることを確認
```
main.tf  modules  provider.tf  README.md  SwitchRoleWithPowerUser.yml
```

### 2.1. 初期化

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
### 2.2. リソース一括デプロイする場合
2.2.1. デバッグ  

(実行コマンド)
```bash
terraform plan
```
下記が出力されればok 

```
module.create_bucket.data.aws_caller_identity.source_account: Reading...
module.create_bucket.data.aws_caller_identity.dest_acctination_account: Reading...
module.create_bucket.data.aws_region.current: Reading...
module.create_bucket.data.aws_region.current: Read complete after 0s [id=ap-northeast-1]

...(中略)
Plan: 5 to add, 0 to change, 0 to destroy.
╷
│ Warning: Reference to undefined provider
│ 
│   on main.tf line 7, in module "create_bucket":
│    7:     aws.dest_acct = aws.master
│ 
│ There is no explicit declaration for local provider name "aws.dest_acct" in module.create_bucket, so Terraform is assuming you mean to pass a configuration for "hashicorp/aws".
│ 
│ If you also control the child module, add a required_providers entry named "aws.dest_acct" with the source address "hashicorp/aws".
│ 
│ (and 3 more similar warnings elsewhere)
╵

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

2.2.2. 適用  
(実行コマンド)
```bash
terraform apply
```
下記が出力されればok 
```

...(中略)
Plan: 5 to add, 0 to change, 0 to destroy.
╷
│ Warning: Reference to undefined provider
│ 
│   on main.tf line 7, in module "create_bucket":
│    7:     aws.dest_acct = aws.master
│ 
│ There is no explicit declaration for local provider name "aws.dest_acct" in module.create_bucket, so Terraform is assuming you mean to pass a configuration for "hashicorp/aws".
│ 
│ If you also control the child module, add a required_providers entry named "aws.dest_acct" with the source address "hashicorp/aws".
│ 
│ (and 3 more similar warnings elsewhere)
╵

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 
```

```yes```と入力してエンター押す
```
  Enter a value: yes

module.create_bucket.aws_s3_bucket.flow_log: Creating...

...(中略)

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
```

### 2.3. リソース単体のデプロイをする場合
2.3.1. デバッグ  
単一のモジュールを実行する  

(実行コマンド)
```bash
terraform plan -target=module.create_bucket
```
下記が出力されればok 

```
module.create_bucket.data.aws_caller_identity.destination_account: Reading...
module.create_bucket.data.aws_caller_identity.source_account: Reading...
module.create_bucket.data.aws_caller_identity.destination_account: Read complete after 1s [id=xxxxxxxxxxxx]
module.create_bucket.data.aws_region.current: Reading...
module.create_bucket.data.aws_region.current: Read complete after 0s [id=ap-northeast-1]
module.create_bucket.data.aws_caller_identity.source_account: Read complete after 1s [id=xxxxxxxxxxxx]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # module.create_bucket.data.aws_iam_policy_document.allow_access_from_another_account will be read during apply
  # (config refers to values not yet known)
 <= data "aws_iam_policy_document" "allow_access_from_another_account" {
      + id   = (known after apply)
      + json = (known after apply)

      + statement {
          + actions   = [
              + "s3:PutObject",
            ]
          + effect    = "Allow"
          + resources = [
              + (known after apply),
            ]
          + sid       = "AWSLogDeliveryWrite"

          + condition {
              + test     = "ArnLike"
              + values   = [
                  + "arn:aws:logs:ap-northeast-1:xxxxxxxxxxxx:*",
                ]
              + variable = "aws:SourceArn"
            }
          + condition {
              + test     = "StringEquals"
              + values   = [
                  + "xxxxxxxxxxxx",
                ]
              + variable = "aws:SourceAccount"
            }
          + condition {
              + test     = "StringEquals"
              + values   = [
                  + "bucket-owner-full-control",
                ]
              + variable = "s3:x-amz-acl"
            }

          + principals {
              + identifiers = [
                  + "delivery.logs.amazonaws.com",
                ]
              + type        = "Service"
            }
        }
      + statement {
          + actions   = [
              + "s3:GetBucketAcl",
              + "s3:ListBucket",
            ]
          + effect    = "Allow"
          + resources = [
              + "arn:aws:s3:::labtest-bucket-01",
            ]
          + sid       = "AWSLogDeliveryCheck"

          + condition {
              + test     = "ArnLike"
              + values   = [
                  + "arn:aws:logs:ap-northeast-1:xxxxxxxxxxxx:*",
                ]
              + variable = "aws:SourceArn"
            }
          + condition {
              + test     = "StringEquals"
              + values   = [
                  + "xxxxxxxxxxxx",
                ]
              + variable = "aws:SourceAccount"
            }

          + principals {
              + identifiers = [
                  + "delivery.logs.amazonaws.com",
                ]
              + type        = "Service"
            }
        }
    }

  # module.create_bucket.aws_s3_bucket.flow_log will be created
  + resource "aws_s3_bucket" "flow_log" {
      + acceleration_status         = (known after apply)
      + acl                         = (known after apply)
      + arn                         = (known after apply)
      + bucket                      = "labtest-bucket-01"
      + bucket_domain_name          = (known after apply)
      + bucket_prefix               = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + object_lock_enabled         = (known after apply)
      + policy                      = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags                        = {
          + "Managed" = "tf-managed"
          + "Name"    = "labtest-bucket-01"
        }
      + tags_all                    = {
          + "Managed" = "tf-managed"
          + "Name"    = "labtest-bucket-01"
        }
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)
    }

  # module.create_bucket.aws_s3_bucket_policy.allow_access_from_another_account will be created
  + resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
      + bucket = (known after apply)
      + id     = (known after apply)
      + policy = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.
╷
│ Warning: Resource targeting is in effect
│ 
│ You are creating a plan with the -target option, which means that the result of this plan may not represent all of the changes requested by the current configuration.
│ 
│ The -target option is not for routine use, and is provided only for exceptional situations such as recovering from errors or mistakes, or when Terraform specifically suggests to use it as part of an
│ error message.
╵
╷
│ Warning: Reference to undefined provider
│ 
│   on main.tf line 7, in module "create_bucket":
│    7:     aws.dest = aws.master
│ 
│ There is no explicit declaration for local provider name "aws.dest" in module.create_bucket, so Terraform is assuming you mean to pass a configuration for "hashicorp/aws".
│ 
│ If you also control the child module, add a required_providers entry named "aws.dest" with the source address "hashicorp/aws".
│ 
│ (and 3 more similar warnings elsewhere)
╵

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

2.3.2 適用  
(実行コマンド)
```bash
terraform apply -target=module.create_bucket
```
下記が出力されればok 
```
module.create_bucket.data.aws_caller_identity.destination_account: Reading...
module.create_bucket.data.aws_caller_identity.destination_account: Read complete after 0s
(...中略)


Plan: 2 to add, 0 to change, 0 to destroy.
╷
│ Warning: Resource targeting is in effect
│ 
│ You are creating a plan with the -target option, which means that the result of this plan may not represent all of the changes requested by the current configuration.
│ 
│ The -target option is not for routine use, and is provided only for exceptional situations such as recovering from errors or mistakes, or when Terraform specifically suggests to use it as part of an
│ error message.
╵
╷
│ Warning: Reference to undefined provider
│ 
│   on main.tf line 7, in module "create_bucket":
│    7:     aws.dest = aws.master
│ 
│ There is no explicit declaration for local provider name "aws.dest" in module.create_bucket, so Terraform is assuming you mean to pass a configuration for "hashicorp/aws".
│ 
│ If you also control the child module, add a required_providers entry named "aws.dest" with the source address "hashicorp/aws".
│ 
│ (and 3 more similar warnings elsewhere)
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


### 99. 参考先URL
- [Appendix E: Deploy a Cross-Account IAM role in AWS Member Accounts](https://docs.aws.amazon.com/ja_jp/solutions/latest/aws-trusted-advisor-explorer/appendix-e.html)
- [Cross Account Role CloudFormation Scripts](https://github.com/spohnan/cf-cross-account-role)
- [Data Source: aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)
- [Providers Within Modules](https://developer.hashicorp.com/terraform/language/modules/develop/providers)
