//Configuration of virtual network.
resource "oci_core_virtual_network" "ClusterVCN" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "ClusterVCN"
  dns_label      = "clustervcn"
}

resource "oci_core_subnet" "ClusterSubnet" {
  count               = "${length(var.ADS)}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.ADS[count.index] -1 ],"name")}"
  cidr_block          = "10.1.${count.index}.0/24"
  display_name        = "SubnetAD${var.ADS[count.index]}"
  dns_label           = "subnetAD${var.ADS[count.index]}"
  security_list_ids   = ["${oci_core_virtual_network.ClusterVCN.default_security_list_id}", "${oci_core_security_list.ClusterSecurityList.id}"]
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.ClusterVCN.id}"
  route_table_id      = "${oci_core_route_table.ClusterRT.id}"
  dhcp_options_id     = "${oci_core_virtual_network.ClusterVCN.default_dhcp_options_id}"
}

resource "oci_core_internet_gateway" "ClusterIG" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "ClusterIG"
  vcn_id         = "${oci_core_virtual_network.ClusterVCN.id}"
}

resource "oci_core_route_table" "ClusterRT" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.ClusterVCN.id}"
  display_name   = "ClusterRT"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.ClusterIG.id}"
  }
}

resource "oci_core_security_list" "ClusterSecurityList" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.ClusterVCN.id}"
  display_name   = "ClusterSecurityList"

  // allow inbound ssh traffic from a specific port
  ingress_security_rules = [
    {
      # Open all ports within the private network
      protocol = "6"
      source   = "10.0.0.0/8"
    },
    {
      # Open port for Narupa
      protocol = "6"
      source   = "0.0.0.0/0"

      tcp_options {
        min = 8000
        max = 8010
      }
    },
    {
      # Open port for Narupa wss
      protocol = "6"
      source   = "0.0.0.0/0"

      tcp_options {
        min = 80
        max = 80
      }
    },
    {
      # Open port for Narupa wss
      protocol = "6"
      source = "0.0.0.0/0"

      tcp_options {
        min = 8080
        max = 8080
      }
    },
  ]

    // allow outbound tcp traffic
  egress_security_rules = [
    {
      # Open port for Narupa
      protocol = "6"
      destination   = "0.0.0.0/0"

      tcp_options {
        min = 8000
        max = 8010
      }
    },
    {
      # Open port for Narupa wss
      protocol = "6"
      destination = "0.0.0.0/0"

      tcp_options {
        min = 80
        max = 80
      }
    },
    {
      # Open port for Narupa wss
      protocol = "6"
      destination = "0.0.0.0/0"

      tcp_options {
        min = 8080
        max = 8080
      }
    },
  ]
}
