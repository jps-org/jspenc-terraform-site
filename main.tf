variable "username" {
}

provider "random" { # an empty for destroying old resources
}

resource "null_resource" "random" {
  triggers = {
    username = var.username
  }
  # only changes when configuration edited, or when username changes.
  provisioner "local-exec" {
    command = "curl https://beyondgrep.com/ack-v3.1.1 > ./ack && chmod 0755 ./ack"
  }
  provisioner "local-exec" {
    command = "./ack randomm"
  }
}

output "random" {
  value = "Changed to: ${null_resource.randomm.id}"
}

output "username" {
  value = "Username is ${var.username}. Extra text."
}

data "terraform_remote_state" "backend" {
  backend = "remote"

  config = {
    hostname = "app.terraform.io"
    organization = "jps"
    
    workspaces = {
      prefix = "jspenc-site-"
    }
  }
}

output "username_out" {
  value = data.terraform_remote_state.backend.outputs.username
}

output "all_out" {
  value = data.terraform_remote_state.backend.outputs
}
