locals {
  environment_map = var.environment_vars == null ? [] : [var.environment_vars]
}