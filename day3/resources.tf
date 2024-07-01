data "digitalocean_ssh_key" "aipc" {
  name = var.do_ssh_key
}

resource "digitalocean_droplet" "codeserver" {
  name = "codeserver"
  image = var.do_image
  region = var.do_region
  size = var.do_size
  
  ssh_keys = [ data.digitalocean_ssh_key.aipc.id ]
}

resource "local_file" "root_at_codeserver" {
    filename = "root@${digitalocean_droplet.codeserver.ipv4_address}"
    content = ""
    file_permission = "0444"
}

resource "local_file" "inventory" {
    content = templatefile("inventory.yaml.tftpl", {
        codeserver_ip = digitalocean_droplet.codeserver.ipv4_address
        ssh_private_key = var.ssh_private_key
        codeserver_password = var.codeserver_password
        codeserver_domain = "code-server-${digitalocean_droplet.codeserver.ipv4_address}.nip.io"
    })
    filename = "inventory.yaml"
    file_permission = "0444"
}

output codeserver_ip {
    value = digitalocean_droplet.codeserver.ipv4_address
}