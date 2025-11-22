variable "tags" {
  type = map(string)
  default = {
    Environment = "production"
    Project     = "workshop-devops-na-nuvem"
  }
}

variable "assume_role" {
  type = object({
    arn    = string
    region = string
  })
  default = {
    arn    = "arn:aws:iam::654654554686:role/workshop-nov-role"
    region = "us-east-1"
  }
}

variable "eks_cluster" {
  type = object({
    name                                   = string
    version                                = string
    enabled_cluster_log_types              = list(string)
    access_config_authentication_mode      = string
    node_group_name                        = string
    node_group_capacity_type               = string
    node_group_instance_types              = list(string)
    node_group_scaling_config_desired_size = number
    node_group_scaling_config_max_size     = number
    node_group_scaling_config_min_size     = number
  })

  default = {
    name                                   = "workshop-nov-eks-cluster"
    version                                = "1.31"
    enabled_cluster_log_types              = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
    access_config_authentication_mode      = "API_AND_CONFIG_MAP"
    node_group_name                        = "workshop-nov-eks-cluster-node-group"
    node_group_capacity_type               = "ON_DEMAND"
    node_group_instance_types              = ["t3.medium"]
    node_group_scaling_config_desired_size = 2
    node_group_scaling_config_max_size     = 2
    node_group_scaling_config_min_size     = 2
  }
}

variable "ecr_repositories" {
  type = list(object({
    name                 = string
    image_tag_mutability = string
  }))

  default = [{
    name                 = "dvn-nov-workshop/production/frontend"
    image_tag_mutability = "MUTABLE"
  },
  {
    name                 = "dvn-nov-workshop/production/backend"
    image_tag_mutability = "MUTABLE"
  }]
}
