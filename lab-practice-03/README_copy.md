# xxx

[xxx](#xxx)  
- [0. CloudFormation StackSets事前準備](#0-cloudformation-stacksets事前準備)  
  - [0.1. 前提条件](#01-前提条件)  
  - [0.2. Self Managed型のアクセス権限作成(管理アカウント側)](#02-self-managed型のアクセス権限作成管理アカウント側)   
  - [0.3. Self Managed型のアクセス権限作成(メンバーアカウント側)](#03-self-managed型のアクセス権限作成メンバーアカウント側)

## 0. CloudFormation StackSets事前準備

- AWSアカウント単位でStackSetsを実行する場合  
[Self Managed型アクセス許可の付与(AWS公式ドキュメント)](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/stacksets-prereqs-self-managed.html)

- Organizations単位でStackSetsを実行する場合  
[Service Managed型アクセス許可の付与(AWS公式ドキュメント)](https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/stacksets-orgs-enable-trusted-access.html)

本手順では、上記のSelf Managed型アクセス許可方法を引用する  

### 0.1. 前提条件
- 複数のAWSアカウントを保有していること
- CloudFormation実行権限を持っていること


### 0.2. Self Managed型のアクセス権限作成(管理アカウント側)

- AWS管理アカウント(マスターアカウント)にサインインし、「CloudFormation」サービスのページへアクセス
- 「スタック」>「スタックの作成」>「新しいリソースを使用(標準)」を選択
- 「テンプレートの準備完了」と「Amazon S3 URL」のラジオボタンがチェックされていることを確認し、Amazon S3 URLの欄に下記リンクを貼り付けて、「次へ」を選択  

```
https://s3.amazonaws.com/cloudformation-stackset-sample-templates-us-east-1/AWSCloudFormationStackSetAdministrationRole.yml
```
※この時、「デザイナーで表示」を新規タブで開くと、実行するCFnテンプレートの内容を確認することができる

- スタック名に任意の名前を入力して「次へ」を選択  

(スタック名の例)
```
CustomManaged-AWSCloudFormationStackSetAdministrationRole
```

- 「スタックオプションの設定」画面では何も入力せず、「次へ」を選択
- デプロイ内容を確認し、末尾の「AWS CloudFormation によって IAM リソースがカスタム名で作成される場合があることを承認します。」のチェックボックスを選択して、「送信」を選択
- 「IAM」サービスのページへアクセスし、「ロール」を選択して「AWSCloudFormationStackSetAdministrationRole」が存在していることを確認

### 0.3. Self Managed型のアクセス権限作成(メンバーアカウント側)

- AWSメンバーアカウントにサインインし、「CloudFormation」サービスのページへアクセス
- 「スタック」>「スタックの作成」>「新しいリソースを使用(標準)」を選択
- 「テンプレートの準備完了」と「Amazon S3 URL」のラジオボタンがチェックされていることを確認し、Amazon S3 URLの欄に下記リンクを貼り付けて、「次へ」を選択  

```
https://s3.amazonaws.com/cloudformation-stackset-sample-templates-us-east-1/AWSCloudFormationStackSetExecutionRole.yml
```

- スタック名に任意の名前を入力し、AdministratorAccountId変数に管理アカウントIDを入力して「次へ」を選択  

(スタック名の例)
```
CustomManaged-AWSCloudFormationStackSetExecutionRole
```

- 「スタックオプションの設定」画面では何も入力せず、「次へ」を選択
- デプロイ内容を確認し、末尾の「AWS CloudFormation によって IAM リソースがカスタム名で作成される場合があることを承認します。」のチェックボックスを選択して、「送信」を選択
- 「IAM」サービスのページへアクセスし、「ロール」を選択して「AWSCloudFormationStackSetExecutionRole」が存在していることを確認

## 1. CFn StackSetsデプロイ

- AWS管理アカウント(マスターアカウント)にサインインし、「CloudFormation」サービスのページへアクセス
- 「StackSets」>「StackSetsの作成」を選択
- 「セルフサービスのアクセス許可」にチェックし、「IAM 管理ロール名」に「AWSCloudFormationStackSetAdministrationRole」を選択
- 「テンプレートの準備完了」と「Amazon S3 URL」のラジオボタンがチェックされていることを確認し、Amazon S3 URLの欄に下記リンクを貼り付けて、「次へ」を選択 
- スタック名に任意の名前を入力して「次へ」を選択 
- 「非アクティブ」にチェックが入っていることを確認して「次へ」を選択
- 「新しいスタックのデプロイ」「スタックをアカウントにデプロイ」のラジオボタンにチェックが入っていることを確認し、「アカウント番号」にスイッチロール先メンバアカウントのIDを入力する
- 「リージョンの指定」に東京リージョンを選択し、「次へ」を選択
- デプロイ内容を確認し、末尾の「AWS CloudFormation によって IAM リソースがカスタム名で作成される場合があることを承認します。」のチェックボックスを選択して、「送信」を選択
- 「スタックインスタンス」タブを開き、ステータスがRUNNINGからSUCCEEDEDになったことを確認する
- スイッチロール先AWSアカウントの

