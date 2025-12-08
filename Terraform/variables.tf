# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "docker_image" {
  description = "docker image name"
  type = string
  default = "a7ryan/simple-time-service:test_v1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "particle41-eks-cluster"
}
