terraform {

  backend "s3" {
    bucket = "watson-owp41rblpfk4810kwuy9twk57dwgpabx"
    key    = "example-voting-app-ecs/terraform.state"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.32.0"
    }
  }
}
