<!-- BEGIN_TF_DOCS -->
# terraform-aws-datadog-intergration

GitHub: [StratusGrid/terraform-aws-datadog-intergration](https://github.com/StratusGrid/terraform-aws-datadog-integration)

This module configures the AWS / Datadog integration.

There are two main components:

1. Datadog core integration, enabling datadog's AWS integration
2. Datadog logs_monitoring forwarder, enabling logshipping watched S3 buckets
* Forward CloudWatch, ELB, S3, CloudTrail, VPC and CloudFront logs to Datadog
* Forward S3 events to Datadog
* Forward Kinesis data stream events to Datadog, only CloudWatch logs are supported
* Forward custom metrics from AWS Lambda functions via CloudWatch logs
* Forward traces from AWS Lambda functions via CloudWatch logs
* Generate and submit enhanced Lambda metrics (aws.lambda.enhanced.*) parsed from the AWS REPORT log: duration, billed_duration, max_memory_used, and estimated_cost


## Examples
```hcl
# Cloudwatch log sync Integration

variable "dd_api_key" {
  type    = string
  default = "1234567890"
}

variable "dd_app_key" {
  type    = string
  default = "1234567890"
}

variable "aws_region" {
  type    = string
  default = "us-west-2"
}

provider "datadog" {
  api_key = var.dd_api_key
  app_key = var.dd_app_key
}

provider "aws" {
  region = var.aws_region
}

module "datadog" {
  source                         = "github.com/StratusGrid/terraform-aws-datadog"
  version                        = "~>1"
  datadog_api_key                = var.dd_api_key
  aws_region                     = var.aws_region
  create_elb_logs_bucket         = false
  enable_datadog_aws_integration = false
  cloudwatch_log_groups          = ["cloudwatch_log_group_1", "cloudwatch_log_group_2"]
}
```
```hcl
# Full Integration

variable "dd_api_key" {
  type    = string
  default = "1234567890"
}

variable "dd_app_key" {
  type    = string
  default = "1234567890"
}

variable "aws_region" {
  type    = string
  default = "us-west-2"
}

provider "datadog" {
  api_key = var.dd_api_key
  app_key = var.dd_app_key
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

module "datadog" {
  source          = "github.com/StratusGrid/terraform-aws-datadog"
  version         = "~>1"
  aws_region      = var.aws_region
  datadog_api_key = var.dd_api_key
  aws_account_id  = data.aws_caller_identity.current.account_id

  cloudtrail_bucket_id  = "S3_BUCKET_ID"
  cloudtrail_bucket_arn = "S3_BUCKET_ARN"

  cloudwatch_log_groups = ["cloudwatch_log_group_1", "cloudwatch_log_group_2"]
}
```
---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.63 |
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | >= 2.10, < 3 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack.datadog_forwarder](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |
| [aws_cloudwatch_log_subscription_filter.test_lambdafunction_logfilter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_iam_policy.datadog_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.datadog_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.datadog_core_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_permission.allow_cloudwatch_logs_to_call_dd_lambda_handler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.allow_ctbucket_trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_lambda_permission.allow_elblog_trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket.elb_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_notification.ctbucket_notification_dd_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_notification.elblog_notification_dd_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [datadog_integration_aws.core](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/integration_aws) | resource |
| [datadog_integration_aws_lambda_arn.main_collector](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/integration_aws_lambda_arn) | resource |
| [datadog_integration_aws_log_collection.main](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/integration_aws_log_collection) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_name"></a> [account\_name](#input\_account\_name) | The account\_name tag to apply to all data sent to datadog | `string` | `""` | no |
| <a name="input_account_specific_namespace_rules"></a> [account\_specific\_namespace\_rules](#input\_account\_specific\_namespace\_rules) | account\_specific\_namespace\_rules argument for datadog\_integration\_aws resource | `map(any)` | `{}` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The ID of the AWS account to create the integration for | `string` | `""` | no |
| <a name="input_aws_integration_tags"></a> [aws\_integration\_tags](#input\_aws\_integration\_tags) | Tags to add to metrics from AWS integration. | `map(any)` | `{}` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | `"us-east-2"` | no |
| <a name="input_cloudtrail_bucket_arn"></a> [cloudtrail\_bucket\_arn](#input\_cloudtrail\_bucket\_arn) | The Cloudtrail bucket ID. Use only from org master account | `string` | `""` | no |
| <a name="input_cloudtrail_bucket_id"></a> [cloudtrail\_bucket\_id](#input\_cloudtrail\_bucket\_id) | The Cloudtrail bucket ID. Use only from org master account. | `string` | `""` | no |
| <a name="input_cloudwatch_log_groups"></a> [cloudwatch\_log\_groups](#input\_cloudwatch\_log\_groups) | Sync logs from cloudwatch by given list of log groups | `list(string)` | `[]` | no |
| <a name="input_create_elb_logs_bucket"></a> [create\_elb\_logs\_bucket](#input\_create\_elb\_logs\_bucket) | Create S3 bucket for ELB log sync | `bool` | `true` | no |
| <a name="input_datadog_api_key_name"></a> [datadog\_api\_key\_name](#input\_datadog\_api\_key\_name) | The API key name for the datadog integration from Secrets Manager. | `string` | n/a | yes |
| <a name="input_dd_forwarder_dd_site"></a> [dd\_forwarder\_dd\_site](#input\_dd\_forwarder\_dd\_site) | Define your Datadog Site to send data to. For the Datadog EU site, set to datadoghq.eu | `string` | `"datadoghq.com"` | no |
| <a name="input_dd_forwarder_log_retention_in_days"></a> [dd\_forwarder\_log\_retention\_in\_days](#input\_dd\_forwarder\_log\_retention\_in\_days) | Defines the log retention period (in days) for CloudWatch logs generated by the DataDog Log Forwarder. | `number` | `90` | no |
| <a name="input_dd_forwarder_template_version"></a> [dd\_forwarder\_template\_version](#input\_dd\_forwarder\_template\_version) | Sets Datadog Forwarder version to use | `string` | `"3.17.0"` | no |
| <a name="input_elb_logs_bucket_prefix"></a> [elb\_logs\_bucket\_prefix](#input\_elb\_logs\_bucket\_prefix) | Prefix for ELB logs S3 bucket name | `string` | `"awsdd"` | no |
| <a name="input_enable_datadog_aws_integration"></a> [enable\_datadog\_aws\_integration](#input\_enable\_datadog\_aws\_integration) | Use datadog provider to give datadog aws account access to our resources | `bool` | `true` | no |
| <a name="input_excluded_regions"></a> [excluded\_regions](#input\_excluded\_regions) | An array of AWS regions to exclude from metrics collection | `list(string)` | `[]` | no |
| <a name="input_filter_tags"></a> [filter\_tags](#input\_filter\_tags) | Array of EC2 tags (in the form key:value) defines a filter that Datadog use when collecting metrics from EC2. Wildcards, such as ? (for single characters) and * (for multiple characters) can also be used. Only hosts that match one of the defined tags will be imported into Datadog. The rest will be ignored. | `list(string)` | `[]` | no |
| <a name="input_log_exclude_at_match"></a> [log\_exclude\_at\_match](#input\_log\_exclude\_at\_match) | Sets EXCLUDE\_AT\_MATCH environment variable, which allows excluding unwanted log lines | `string` | `"$x^"` | no |
| <a name="input_reserved_concurrency"></a> [reserved\_concurrency](#input\_reserved\_concurrency) | Lambda reserved concurrency for Datadog Forwarder. | `number` | `100` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_datadog_iam_role"></a> [datadog\_iam\_role](#output\_datadog\_iam\_role) | tflint-ignore: terraform\_documented\_outputs -- Ignore Notice on missing description |
| <a name="output_datadog_logs_monitoring_lambda_function_name"></a> [datadog\_logs\_monitoring\_lambda\_function\_name](#output\_datadog\_logs\_monitoring\_lambda\_function\_name) | tflint-ignore: terraform\_documented\_outputs -- Ignore Notice on missing description |

---

<span style="color:red">Note!</span>
---
Manual changes to the README will be overwritten when the documentation is updated. To update the documentation, run `terraform-docs -c .config/.terraform-docs.yml`
<!-- END_TF_DOCS -->