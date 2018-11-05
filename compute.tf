resource "oci_core_instance" "ClusterManagement" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.ManagementAD - 1], "name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "mgmt"
  shape               = "${var.ManagementShape}"

  create_vnic_details {
    # ManagementAD
    #subnet_id        = "${oci_core_subnet.ClusterSubnet.id}"
    subnet_id = "${oci_core_subnet.ClusterSubnet.*.id[index(var.ADS, var.ManagementAD)]}"

    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "mgmt"
  }

  source_details {
    source_type = "image"
    source_id   = "${var.ManagementImageOCID[var.region]}"
  }

  metadata {
    ssh_authorized_keys = "${file(var.ssh_public_key)}${data.tls_public_key.oci_public_key.public_key_openssh}"
    user_data           = "${base64encode(file(var.BootStrapFile))}"
  }

  timeouts {
    create = "60m"
  }

  freeform_tags = {
    "cluster"  = "${var.ClusterNameTag}"
    "nodetype" = "mgmt"
  }
}

resource "null_resource" "setup" {
  depends_on = ["oci_core_instance.ClusterManagement"]

  triggers {
     cluster_instance = "${oci_core_instance.ClusterManagement.id}"
  }

  provisioner "remote-exec" {
    script = "script/setup.sh"
    connection {
        timeout = "15m"
        host = "${oci_core_instance.ClusterManagement.*.public_ip}"
        user = "opc"
        private_key = "${file(var.private_key_path)}"
        agent = false
    }
  }
}
