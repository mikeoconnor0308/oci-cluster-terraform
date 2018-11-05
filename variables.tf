variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}

variable "ADS" {
  description = "The list of ADs you want to create your cluster across."
  default = ["1"]
}

variable "ManagementAD" {
  description = "The AD the management node should live in."
  default = "1"
}

variable "ManagementShape" {
  description = "The shape to use for the management node"
  default = "VM.Standard2.1"
}

variable "ManagementImageOCID" {
  description = "What image to use for the management node. A map of region name to image OCID."
  type = "map"

  default = {
    // See https://docs.us-phoenix-1.oraclecloud.com/images/
    // Ubuntu 16.04
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaajxg7h2afqlesebr3qde2q562juauobyotat3aiphjikbf4v72z3a"
  }
}

variable "BootStrapFile" {
  default = "./script/setup.sh"
}

variable "ClusterNameTag" {
  default = "cluster"
}
