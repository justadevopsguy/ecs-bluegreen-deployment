locals {
  mongodb_atlas_org_id            = "6422b016415b965f3d85b123"
  mongo_atlas_project_name        = "ecs-project"
  mongodb_atlas_database_username = "dbadmin"
}

resource "random_password" "atlas_password" {
  length           = 32
  special          = true
  override_special = "_!"
  min_special      = 1
  min_numeric      = 1
  min_lower        = 1
  min_upper        = 1
}


resource "aws_ssm_parameter" "atlas_password" {
  name        = "/production/mongodb/db-master-password"
  description = "Atlas master password"
  type        = "SecureString"
  value       = random_password.atlas_password.result
}

resource "mongodbatlas_project" "ecs_atlas" {
  name   = local.mongo_atlas_project_name
  org_id = local.mongodb_atlas_org_id
}


# Create a Free Shared Tier Cluster
resource "mongodbatlas_cluster" "ecs_cluster" {
  project_id = mongodbatlas_project.ecs_atlas.id
  name       = "ecs-db-shared"

  provider_name = "TENANT"

  backing_provider_name = "AWS"
  provider_region_name  = "AP_SOUTHEAST_1"

  provider_instance_size_name = "M0"

  mongo_db_major_version       = "5.0"
  auto_scaling_disk_gb_enabled = "false"
}

resource "mongodbatlas_database_user" "my_user" {
  username           = local.mongodb_atlas_database_username
  password           = aws_ssm_parameter.atlas_password.value
  project_id         = mongodbatlas_project.ecs_atlas.id
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }
}

