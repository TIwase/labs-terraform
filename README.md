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
- [createVPC](https://github.com/TIwase/labs-terraform/tree/main/lab-practice-01/aws-createVpc)

