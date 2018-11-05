//Sets up the instance.
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
    ssh_authorized_keys = "${var.ssh_public_key}"
  }

  timeouts {
    create = "60m"
  }

  freeform_tags = {
    "cluster"  = "${var.ClusterNameTag}"
    "nodetype" = "mgmt"
  }
}

//Copies over the files and runs setup.

resource "null_resource" "setup" {
  depends_on = ["oci_core_instance.ClusterManagement"]

  triggers {
     cluster_instance = "${oci_core_instance.ClusterManagement.id}"
  }

  provisioner "file" {
    destination = "openmm"
    source = "../openmm"
    connection {
      timeout = "1m"
      host = "${oci_core_instance.ClusterManagement.*.public_ip}"
      user = "ubuntu"
      private_key = "${var.ssh_private_key}"
      agent = false
    }
  }


  provisioner "file" {
    destination = "bin"
    source = "../bin"
    connection {
      timeout = "1m"
      host = "${oci_core_instance.ClusterManagement.*.public_ip}"
      user = "ubuntu"
      private_key = "${var.ssh_private_key}"
      agent = false
    }
  }

  provisioner "remote-exec" {
    script = "script/setup.sh"
    connection {
        timeout = "1m"
        host = "${oci_core_instance.ClusterManagement.*.public_ip}"
        user = "ubuntu"
        private_key = "${var.ssh_private_key}"
        agent = false
    }
  }
}
