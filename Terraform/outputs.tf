output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "region" {
  value = var.region
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "application_url" {
  value = (
    length(kubernetes_service.time-service.status[0].load_balancer[0].ingress) > 0 ?
    coalesce(
      kubernetes_service.time-service.status[0].load_balancer[0].ingress[0].hostname,
      kubernetes_service.time-service.status[0].load_balancer[0].ingress[0].ip
    ) : ""
  )
}
