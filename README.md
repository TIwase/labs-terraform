# terraformテスト環境利用方法
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
- awsの場合  

SSOポータルサイトにサインインし、対象AWSアカウントの[Command line or programmatic access]を選択  
[Option 2: Add a profile to your AWS credentials file]に記載されている値をクリック(コピー)する  
以下コマンドを実行して、コピーした値をペーストする
```bash
vi ~/.aws/credentials
```
(記載例)
```bash
[default]
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

(実行例)
```bash
cd ./
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
terraform plan -var-file=vars.tfvars
```

下記が出力されればok 
```bash
...(中略)
Plan: 2 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```
### 1.3. 適用

下記コマンドを実行
```bash
terraform apply -var-file=vars.tfvars
```
下記が出力される
```bash
...(中略)
Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```
```yes```と入力してエンター押す  
問題なくデプロイ完了すると下記が出力される  
```bash
...(中略)
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```
デプロイした際のリソースの変数は、terraform.tfstateに記録される  
※```terraform apply```時にエラーが出力された場合、該当のtfファイルを編集し、terraform.tfstateを削除orリネームした上で再度、```terraform init```から実施すること

### 1.4. 切り戻し

削除したいAWSリソースの内容を確認する
```bash
terraform plan -destroy
```
AWSリソースの削除
```bash
terraform destroy
```

