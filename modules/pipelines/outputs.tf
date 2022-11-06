output "codebuild_name" {
  value = aws_codebuild_project.build_project.name
}

output "codebuild_arn" {
  value = aws_codebuild_project.build_project.arn
}

output "codepipeline_name" {
  value = aws_codepipeline.codepipeline.name
}

output "codepipeline_arn" {
  value = aws_codepipeline.codepipeline.arn
}
