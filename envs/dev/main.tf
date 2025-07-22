module "resource_group" {
  source = "../../modules/resource_group" 
  name   = "tf-labs-rg"                   
  location = "South Africa North"
  tags = {
    environment = "Dev"
    project     = "tf-labs-3TierApp"
  }
}