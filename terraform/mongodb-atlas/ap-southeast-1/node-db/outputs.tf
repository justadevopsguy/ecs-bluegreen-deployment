output "connection_strings" {
  value = mongodbatlas_cluster.ecs_cluster.connection_strings.0.standard_srv
}