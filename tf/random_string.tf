resource "random_string" "unique" {
  length  = 2
  numeric = true
  special = false
}
##Create Random Password
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}