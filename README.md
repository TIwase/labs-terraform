# terraformテスト環境利用方法

[terraformテスト環境利用方法](#terraformテスト環境利用方法)  
- [0. gitpod起動](#0-gitpod起動)  
  - [0.1. terraformのインストール](#01-terraformのインストール)  
  - [0.2. terraformのバージョンを指定する場合](#02-terraformのバージョンを指定する場合)   
  - [0.3. クラウドのCredentials設定](#03-クラウドのcredentials設定)
- [1. terraform実行](#1-terraform実行)

## 0. gitpod起動
### 0.1. terraformのインストール
以下のURLにアクセスする
```
gitpod.io/#https://github.com/TIwase/labs-terraform
```
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/TIwase/labs-terraform)  

自動でtfenvとterraformの最新版がインストールされる  

※terraform最新バージョンを利用する場合は手順0.3へスキップ  
※terraformのバージョンを明示的に指定する場合、手順0.2へ

### 0.2. terraformのバージョンを指定する場合
以下コマンドを実行して利用可能なterraformのバージョンを探す
```bash
tfenv list-remote
```
以下コマンドで対象バージョンをインストール  
(実行例)
```bash
tfenv install 1.1.7
```
以下コマンドでterraformのバージョンを適用する  
(実行例)
```bash
tfenv use 1.1.7
```
terraformのバージョン確認
```bash
terraform --version
```
### 0.3. クラウドのCredentials設定
- aws SSOの場合  

SSOポータルサイトにサインインし、対象AWSアカウントの[Command line or programmatic access]を選択  
[Option 2: Add a profile to your AWS credentials file]に記載されている値をクリック(コピー)する  

- aws IAMの場合  
AWSマネジメントコンソールにサインイン後、一番右上の[IAMユーザ名@アカウント名]をクリックし、[Security credentials]を選択  
[Access keys] > [Create access key]をクリックし、[Command Line Interface (CLI)]を選択してアクセスキーを作成する  
アクセスキーとシークレットキーが表示されるので控えておく (csv形式でダウンロード可能)


以下コマンドを実行して、コピーした値をペーストする
```bash
vi ~/.aws/credentials
```
(IAM記載例)
```bash
[default]
aws_access_key_id=ASIAxxxx
aws_secret_access_key=xxxxxx
```
※複数AWSアカウントのリソースデプロイする場合は、Configファイルに下記プロファイルを追記すること
```bash
vi ~/.aws/config
```
```bash
[default]
region=ap-northeast-1
output=json
cli_pager=

# 複数AWSアカウントのリソースデプロイする場合は下記プロファイルを追記
[profile iwt-member-acct]
source_profile=default
role_arn=arn:aws:iam::xxxxxxxxxxxx:role/iwt-member-acct-switchrole # クロスアカウント用IAM Roleのarnを追記
role_session_name=session_iwt-member-acct # 任意の名前
```

(SSO記載例)  
以下コマンドを実行して、コピーした値をペーストする
```bash
vi ~/.aws/credentials
```
```bash
[default]
aws_access_key_id=ASIAxxxx
aws_secret_access_key=xxxxxx
aws_session_token=xxxxxxxxxxxx

# 複数AWSアカウントに対してリソースデプロイする場合は下記プロファイルを追記
[iwt-member-acct]
aws_access_key_id=ASIAxxxx
aws_secret_access_key=xxxxxx
aws_session_token=xxxxxxxxxxxx

```
以下コマンド実行で登録したCredentialsの確認
```bash
aws configure list
```
(実行例)
```bash
      Name                    Value             Type    Location
      ----                    -----             ----    --------
   profile                <not set>             None    None
access_key     ****************PITZ shared-credentials-file    
secret_key     ****************o/SK shared-credentials-file    
    region           ap-northeast-1      config-file    ~/.aws/config
```
※terraform適用先リージョンを修正する場合、~/.aws/configファイルを編集する

## 1. terraform実行

実行したいterraformテンプレート配下へ移動  
- [create VPC](./lab-practice-01/aws-createVpc/)
- [create EC2 Instance](./lab-practice-02/)
- [export VPC flow log to S3 bucket in another account](./lab-practice-03/)
