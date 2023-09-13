module "permissions" {
    source = "../role_permissions"

    for_each = var.permissions

    role_id = aws_iam_role.this.id
    role_name = "${aws_lambda_function.this.function_name}-${each.key}"

    effect = each.value.effect
    sid = each.value.sid
    actions = each.value.actions
    resources = each.value.resources
}