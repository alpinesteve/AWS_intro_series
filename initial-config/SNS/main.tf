provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_sns_topic" "security_alerting" {
  name = "Security-Alerting"

}

resource "aws_sns_topic_policy" "security_alerting_policy" {
  arn = "${aws_sns_topic.security_alerting.arn}"
  policy = "${data.aws_iam_policy_document.security_alerting_policy_document.json}"
}

data "aws_iam_policy_document" "security_alerting_policy_document" {
  policy_id = "security_policy"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        "${var.account_id}",
      ]
    }

    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "*"]
    }

    resources = [
      "${aws_sns_topic.security_alerting.arn}",
    ]

    sid = "__default_statement_ID"
  }
}