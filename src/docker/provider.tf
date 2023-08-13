# ----------- Provider ----------

terraform {

  # Terraform relies on plugins called "providers" to interact with remote systems
  required_providers {
    docker = {                       # Source Local Name 
      source  = "kreuzwerker/docker" # Source Address to Terraform Registry [<HOSTNAME>/]<NAMESPACE>/<TYPE>
      version = "~> 3.0.1"           # Compatible Version on https://registry.terraform.io/browse/providers?product_intent=terraform
    }
  }
}

# -----------Provider Configuration----------

provider "docker" {
  host = "npipe:////.//pipe//docker_engine" 
}
