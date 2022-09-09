variable ingress_ports {
  type = list(string)
  default = ["22", "80", "443", "110", "993", "8080"]
  description = "List of ingress ports for default security group"
}