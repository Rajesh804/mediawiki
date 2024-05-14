resource "aws_ecr_repository" "repo" {
  name = var.name
  tags = {
    Name = var.name
  }
  image_scanning_configuration {
    scan_on_push = true

  }
}

//resource "aws_ecr_repository" "repoDev" {
//  name = "dev-image/${var.name}"
//}
data "aws_caller_identity" "current" {
}

data "aws_iam_policy_document" "repo" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchDeleteImage",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DeleteLifecyclePolicy",
      "ecr:DeleteRepository",
      "ecr:DeleteRepositoryPolicy",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetRepositoryPolicy",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:PutImage",
      "ecr:PutLifecyclePolicy",
      "ecr:SetRepositoryPolicy",
      "ecr:StartLifecyclePolicyPreview",
      "ecr:UploadLayerPart"
    ]
    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
      type = "AWS"
    }
    sid = "AllowPushAccess"
  }
}


//data "aws_iam_policy_document" "repodev" {
//   statement {
//    actions = [
//      "ecr:BatchCheckLayerAvailability",
//        "ecr:BatchDeleteImage",
//        "ecr:BatchGetImage",
//        "ecr:CompleteLayerUpload",
//        "ecr:DeleteLifecyclePolicy",
//        "ecr:DeleteRepository",
//        "ecr:DeleteRepositoryPolicy",
//        "ecr:DescribeImages",
//        "ecr:DescribeRepositories",
//        "ecr:GetDownloadUrlForLayer",
//        "ecr:GetLifecyclePolicy",
//        "ecr:GetLifecyclePolicyPreview",
//        "ecr:GetRepositoryPolicy",
//        "ecr:InitiateLayerUpload",
//        "ecr:ListImages",
//        "ecr:PutImage",
//        "ecr:PutLifecyclePolicy",
//        "ecr:SetRepositoryPolicy",
//        "ecr:StartLifecyclePolicyPreview",
//        "ecr:UploadLayerPart"
//    ]
//    principals {
//      identifiers = flatten([
//        var.cross_account_users
//      ])
//      type = "AWS"
//    }
//    sid = "AllowPushAccess"
//  }
//}




resource "aws_ecr_repository_policy" "repo" {
  policy = data.aws_iam_policy_document.repo.json
  repository = aws_ecr_repository.repo.name
}

//resource "aws_ecr_repository_policy" "repodev" {
//  policy     = data.aws_iam_policy_document.repodev.json
//  repository = aws_ecr_repository.repoDev.name
//}


resource "aws_ecr_lifecycle_policy" "repo" {
  policy = file("${path.module}/lifecycle-policy.json")
  repository = aws_ecr_repository.repo.name
}

//resource "aws_ecr_lifecycle_policy" "repodev" {
//  policy     = file("${path.module}/lifecycle-policy.json")
//  repository = aws_ecr_repository.repoDev.name
//}
