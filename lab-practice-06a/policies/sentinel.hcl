policy "restrict-aws-instance-tag" {
  source = "./restrict-aws-instance-tag.sentinel"
  enforcement_level = "hard-mandatory"
}
mock "tfplan/v2" {
  module {
    source = "mock-tfplan-v2.sentinel"
  }
}

