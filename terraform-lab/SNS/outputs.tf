output "topic_arn1" {

    value = aws_sns_topic.sns_topic.arn
    description = "Topic created successfully"

}
output "subscription_arn1" {

    value = aws_sns_topic_subscription.sns_subscription.arn
    description = "Subscription created successfully. Confirm the subscription on your mail"

}