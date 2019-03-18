### Region
region = "eu-frankfurt-1"
ADS = ["3"]

ClusterNameTag = "GPU Cluster"

ManagementAD = "3"
FilesystemAD = "3"
InstanceADIndex = ["3", "3"]
ManagementShape = "VM.Standard2.2"
ComputeShapes = ["VM.GPU2.1", "VM.GPU2.1"]
ComputeImageOCID = {
  VM.GPU2.1 = {
    // See https://docs.cloud.oracle.com/iaas/images/
    // Oracle-Linux-7.6-Gen2-GPU-2019.01.17-0
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaasmqd4eownxal3jw3mg5p3kpg2vhg2wh2uix56eabvzdsnqzb27ma"  
    }
}
ManagementImageOCID = {
  // See https://docs.cloud.oracle.com/iaas/images/
  // Oracle-Linux-7.6-Gen2-2019.01.17-0
  eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaagbrvhganmn7awcr7plaaf5vhabmzhx763z5afiitswjwmzh7upna"
}
