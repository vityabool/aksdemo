variable "resource_group_name" {
  type = string
  default = "wellnesstrace"
}

variable "container_registr_name" {
  type = string
  default = "wtacr101"
}

variable "location" {
  type = string
  default = "North Europe"
}

variable "mysql_name" {
  type = string
  default = "twmysql"
}

variable "wtsql_administrator_login" {
  type = string
  default = "mysqladmin"
}

variable "wtsql_administrator_login_password" {
  type = string
  default = "U0baR3&U"
}

variable "db_name" {
  type = string
  default = "wtdb"
}
