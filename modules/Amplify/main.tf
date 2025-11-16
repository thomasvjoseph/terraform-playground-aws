resource "aws_amplify_app" "AmplifyApp" {
  name       = var.name
  repository = var.repository

  # The default build_spec added by the Amplify Console for React.
  build_spec = <<-EOT
    version: 1
    frontend:
    phases:
        preBuild:
        commands:
            - npm install
        build:
        commands:
            - npm run build
    artifacts:
        baseDirectory: .next
        files:
        - '**/*'
    cache:
        paths:
        - .next/cache/**/*
        - .npm/**/*
        - node_modules/**/*
    EOT

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  environment_variables = {
    ENV = "test"
  }
}

resource "aws_amplify_branch" "branch" {
  app_id      = aws_amplify_app.AmplifyApp.id
  branch_name = "master"
}

resource "aws_amplify_webhook" "webhook" {
  app_id      = aws_amplify_app.AmplifyApp.id
  branch_name = aws_amplify_branch.branch.branch_name
  description = "triggermaster"
}