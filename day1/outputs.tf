output "droplet_public_ip" {
	value = digitalocean_droplet.myaipcdemo.ipv4_address
}
