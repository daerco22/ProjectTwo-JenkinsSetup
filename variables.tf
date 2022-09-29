variable "local_ip" {
  type        = string
  description = "Wifi/Local IP"
}

variable "user_data" {
  type        = string
  description = "user data template"
}

variable "host_os" {
  type        = string
  description = "host operating system"
}

variable "access_key" {
  type = string
  description = "aws access key"
}

variable "secret_key" {
  type = string
  description = "aws secret key"
}