data "terraform_remote_state" "route53_ajq" {
  backend = "s3"
  config = {
    bucket         = "ajq-terraform"
    key            = "aws/production/global/route53/ecs.ajquiambao.com.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "ajq-terraform-lock"
    profile        = "aj-ecs"
  }
}