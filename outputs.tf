#tflint-ignore: terraform_documented_outputs -- Ignore Notice on missing description
output "datadog_logs_monitoring_lambda_function_name" {
  value = aws_cloudformation_stack.datadog_forwarder.outputs.DatadogForwarderArn
}

#tflint-ignore: terraform_documented_outputs -- Ignore Notice on missing description
output "datadog_iam_role" {
  value = var.enable_datadog_aws_integration ? aws_iam_role.datadog_integration[0].name : ""
}