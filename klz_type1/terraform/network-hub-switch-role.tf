# Switch role to be able to read the VPC + Subnets from networking pipeline

resource "aws_iam_role" "assume_role" {
  name                = "assume_role"
  assume_role_policy  = aws_iam_policy_document.assume_role.json
  managed_policy_arns = [aws_iam_policy.assume_role_policy.arn]
}

# Trust policy
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::606864724315:user/github_actions_user"]
    }
  }
}

# Permissions policy
resource "aws_iam_policy" "assume_role_policy" {
  name = "networking-pipeline-vpc-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect": "Allow",
        "Action": [
            "ec2:DescribeVpcAttribute",
            "ec2:ModifyVpcAttribute",
            "ec2:CreateVpc",
            "ec2:DescribeVpcs",
            "ec2:CreateSubnet",
            "ec2:DescribeSubnets",
            "ec2:DescribeAvailabilityZones",
            "ec2:CreateRouteTable",
            "ec2:CreateRoute",
            "ec2:CreateInternetGateway",
            "ec2:AttachInternetGateway",
            "ec2:AssociateRouteTable",
            "ec2:CreateTransitGatewayVpcAttachment",
            "ec2:DescribeTransitGatewayVpcAttachments",
            "ec2:DescribeTransitGatewayAttachments",
            "ec2:DescribeTransitGateways"
        ],
        "Resource": "*"
      },
    ]
  })
}

