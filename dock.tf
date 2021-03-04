terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  
}

resource "docker_image" "flaskapp" {
  name         = "flaskapp:latest"
  keep_locally = false
}

resource "docker_container" "flaskapp" {
  image = gmn_docker_image.latest
  name  = "tutorial"
  ports {
    internal = 9090
    external = 8000
  }
}
