# variable "access_key" {
#    description = "Access key to AWS console"}
#variable "secret_key" {
#    description = "Secret key to AWS console"}
variable "region" {
    description = "AWS region"
}
variable "sns_subscription_email" {
  type = string
  description = "Email endpoint for the SNS subscription"
}