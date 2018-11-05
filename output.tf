# Output the private and public IPs of the instance
#output "ManagementPrivateIPs" {
#  value = ["${oci_core_instance.ClusterManagement.*.private_ip}"]
#}

#output "ManagementHostnames" {
#  value = ["${oci_core_instance.ClusterManagement.*.display_name}"]
#}

output "ManagementPublicIPs" {
  value = ["${oci_core_instance.ClusterManagement.*.public_ip}"]
}

output "SSHPublicKey" {
  value = "${oci_core_instance.ClusterManagement.*.metadata.ssh_authorized_keys}"
}