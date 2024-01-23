resource "aws_iam_role" "ebs_csi_driver_role" {
  name = "eks-ebs-csi-driver-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_policy" "ebs_csi_driver_policy" {
  name        = "eks-ebs-csi-driver-policy"
  description = "IAM policy for EBS CSI driver on EKS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["ec2:AttachVolume", "ec2:DetachVolume", "ec2:DescribeVolumes", "ec2:DescribeInstances"],
        Effect   = "Allow",
        Resource = "*",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy_attachment" {
  policy_arn = aws_iam_policy.ebs_csi_driver_policy.arn
  role       = aws_iam_role.ebs_csi_driver_role.name
}