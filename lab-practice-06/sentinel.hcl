policy "restrict-aws-instance-tag" {
  enforcement_level = "hard-mandatory"
}
mock "tfplan/v2" {
  module {
    source = "mock-tfplan-v2.sentinel"
  }
}

