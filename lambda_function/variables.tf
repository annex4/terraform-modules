variable "name" {
  description = "Name of function"
  type = string
}

variable "timeout" {
  description = "Timeout of the lambda function"
  type = number
  default = 10
}

variable "handler" {
  type = string
  default = "dist/index.handler"
}
variable "runtime" {
  type = string
  default = "nodejs14.x"
  description = "The node JS runtime of the lambda function"
}

variable "environment_vars" {
  type = map(string)
  description = "Environment variables for the lambda function"
}

variable "directory" {
  type = string
  description = "The path to the lambda function directory"
}

variable "application" {
  type = string
  description = "Where the application resides in the directory"
}

variable "region" {
  type = string
}

variable "account" {
  type = string
}

variable "permissions" {
    type = map(object({
        resources = set(string)
        actions = set(string)
        effect = string
        sid = string
    }))
    default = {}
}

variable "layers" {
    type = set(string)
    default = []
}