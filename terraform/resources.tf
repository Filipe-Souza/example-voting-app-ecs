resource "random_password" "rds_db_password" {
  length  = 32
  special = false
}
