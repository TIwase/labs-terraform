
# 作成したキーペアを格納するファイルを指定。
# 存在しないディレクトリを指定した場合は新規にディレクトリを作成してくれる
locals {
  public_key_file  = "./.key_pair/${var.key_name}.id_rsa.pub"
  private_key_file = "./.key_pair/${var.key_name}.id_rsa"
}

# privateキーのアルゴリズム設定
resource "tls_private_key" "keygen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# SSH秘密鍵のパーミッション変更
resource "local_file" "private_key_pem" {
  filename = local.private_key_file
  content  = tls_private_key.keygen.private_key_pem
  provisioner "local-exec" {
    command = "chmod 600 ${local.private_key_file}"
  }
  depends_on = [ 
    tls_private_key.keygen 
  ]
}

# SSH公開鍵のパーミッション変更
resource "local_file" "public_key_openssh" {
  filename = local.public_key_file
  content  = tls_private_key.keygen.public_key_openssh
  provisioner "local-exec" {
    command = "chmod 600 ${local.public_key_file}"
  }
  depends_on = [ 
    tls_private_key.keygen 
  ]
}

# AWSのキーペアに公開鍵を登録
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.keygen.public_key_openssh
  depends_on = [ 
    tls_private_key.keygen 
  ]
  tags = {
    Managed = var.TAG_MANAGED
  }
}
