resource "aws_iam_role_policy" "this" {
  name   = "${var.role_name}"
  role   = var.role_id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = var.effect
    actions = var.actions
    resources = var.resources
    sid = var.sid
  }
}