resource "aws_iam_role" "cluster_role" {
  name = "cluster_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = var.env
  }
}

resource "aws_iam_policy_attachment" "cluster_policy_attachment" {
  name = "cluster_policy_attachment"
  roles = [aws_iam_role.cluster_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

data "aws_vpc" "vpc" {
  default = true
}

data "aws_subnets" "subnet" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

resource "aws_eks_cluster" "my_cluster" {
  name = "my_cluster"

  access_config {
    authentication_mode = "API"
  }

  role_arn = [aws_iam_role.cluster.arn]
  version  = "1.31"

  vpc_config {
    subnet_ids =  data.aws_subnets.subnet.ids
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy_attachment
  ]

  timeouts {
     create = "20m"    
  }
}

resource "aws_iam_role" "node_role" {
  name = "node_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "node_policy_attachment" {
  name = "cluster_policy_attachment"
  roles = [aws_iam_role.node_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_policy_attachment" "node_policy_attachment_wkn" {
  name = "cluster_policy_attachment"
  roles = [aws_iam_role.node_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_policy_attachment" "node_policy_attachment_ec2" {
  name = "cluster_policy_attachment"
  roles = [aws_iam_role.node_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "my_node_group"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = data.aws_subnets.subnet.ids
  instance_types = "t3.small"

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
   aws_iam_policy_attachment.node_policy_attachment,
   aws_iam_policy_attachment.node_policy_attachment_wkn,
   aws_iam_policy_attachment.node_policy_attachment_ec2
  ]
  timeouts {
    create = "20m"
  }
}