variable "role_id" {
    type = string
}

variable "role_name" {
    type = string
}

variable "effect" {
    type = string
    default = "Allow"
}

variable "sid" {
    type = string
}

variable "actions" {
    type = list(string)
}

variable "resources" {
    type = list(string)
}