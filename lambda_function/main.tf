locals {
    commands = tomap({
        "src" = "del /q build && npm install"
        "typescript" = "del /q build && npm install && tsc",
        "webpack" = "del /q dist && npm install && npx webpack",
        "rush" = "rushx build"
    })

    excludes = tomap({
        "src" = ["package-lock.json", "layer", "test", "build"]
        "typescript" = ["package-lock.json", "layer", "test", "build", "src"]
        "webpack" = ["package-lock.json", "layer", "test", "build", "node_modules", "src", "webpack.config.js"],
        "rush" = ["package-lock.json", "layer", "test", "build", "node_modules", "src", "webpack.config.js", "config", ".rush"]
    })

    path = "${path.root}/../../../packages/server/${var.directory}"
}

resource "aws_lambda_function" "this" {
  filename      = data.archive_file.application.output_path
  function_name = "${var.name}"
  role          = aws_iam_role.this.arn
  handler       = var.handler
  timeout       = var.timeout

  source_code_hash = data.archive_file.application.output_base64sha256

  runtime = var.runtime
  layers = var.layers

  dynamic "environment" {
    for_each = local.environment_map
    content {
      variables = environment.value
    }
  }

  depends_on = [
    data.archive_file.application
  ]
}

resource "null_resource" "build" {
  provisioner "local-exec" {
    working_dir = local.path
    command = local.commands[var.application]
  }

  triggers = {
    source_change = sha1(join("", [for f in fileset("${local.path}/src", "**"): filesha1("${local.path}/src/${f}")]))
    run_on_package_change = filebase64sha256("${local.path}/package.json")
    force = true
  }
}

data "archive_file" "application" {
    type = "zip"
    source_dir = "${local.path}"
    output_path = "${local.path}/build/lambda.zip"
    excludes = local.excludes[var.application]

    depends_on = [null_resource.build]
}