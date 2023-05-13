provider "aws" {
 
  profile = var.profile
  region  = var.region

}

locals {
    sqs = csvdecode(file(var.file_location))
}


resource "aws_sqs_queue" "this" {
  count                       = length(local.sqs)
  name                        = local.sqs[count.index]["QueueName"]
  visibility_timeout_seconds  = local.sqs[count.index]["VisibilityTimeout"]
  delay_seconds               = local.sqs[count.index]["DelaySeconds"]
  max_message_size            = local.sqs[count.index]["MaximumMessageSize"]
  message_retention_seconds   = local.sqs[count.index]["MessageRetentionPeriod"]
  receive_wait_time_seconds   = local.sqs[count.index]["ReceiveMessageWaitTimeSeconds"]
  fifo_queue                  = lower(local.sqs[count.index]["FifoQueue"])
  content_based_deduplication = lower(local.sqs[count.index]["ContentBasedDeduplication"])
  kms_master_key_id           = lower(local.sqs[count.index]["KMSKeyID"])

}


resource "aws_sqs_queue_policy" "this" {
  count     = length(local.sqs)
  queue_url = aws_sqs_queue.this.*.id[count.index]
  policy    = local.sqs[count.index]["AccessPolicy"]
}





output "file" {

  value = var.file_location

}

/*

output "lenght" {

    value = length(local.sqs)
}

*/