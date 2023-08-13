# -----------Resources----------
# Each resource block describes one or more infrastructure objects,
# such as virtual networks, compute instances, or higher-level components such as DNS records.

variable "docker_ports" {
  type = list(object({
    internal = number
    external = number
    protocol = string
  }))
  default = [
    {
      internal = 80
      external = 8000
      protocol = "tcp"
    }
  ]
}

# Example of using Docker to run NGINX server 
resource "docker_image" "nginx" {
  name         = "nginx"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "tutorial"

  ports {
    internal = var.docker_ports.internal
    external =  var.docker_ports.external
  }
}
