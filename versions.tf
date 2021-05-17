terraform {
  required_version = ">= 0.13"

  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = ">= 2.10, < 3"
    }
  }
}
