terraform {
  required_version = ">= 1.1"

  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = ">= 2.10, < 3"
    }
    aws = {
      version = ">= 3.63"
    }
  }
}
