variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "The target AWS region for the genomic infrastructure."
}

variable "organization" {
  type        = string
  default     = "seqcenter" # Guided Option: Change this to match your lab name (e.g., "upmc" or "ahn")
  description = "The name of the organization deploying this blueprint."
}

variable "environment" {
  type        = string
  default     = "dev" # Options: dev, staging, prod
  description = "Deployment environment tag used for strict cost and boundary isolation."
}

# ==============================================================================
# COMPUTE SCALE SELECTION GUIDE
# ==============================================================================
# Before deploying, the Bioinformatics team must define the workload profile 
# by answering these three core sizing questions:
#
# 1. WHAT PIPELINE STAGE IS RUNNING?
#    - Alignment (BWA-MEM, Bowtie2) requires massive CPU and RAM.
#    - Variant Calling (GATK, DeepVariant) benefits from high-clock compute or GPU.
#    - Quality Control (FastQC) is fast and can use low-tier instances.
#
# 2. WHAT IS THE SEQUENCING DATA SIZE?
#    - Small Panels/Targeted (e.g., 20x coverage panel): < 5 GB FastQ files.
#    - Whole Exome Sequencing (WES): ~10-15 GB FastQ files.
#    - Whole Genome Sequencing (WGS): > 100 GB FastQ files per sample.
#
# 3. WHAT IS THE PIPELINE ENGINE BEING USED?
#    - Nextflow / Snakemake orchestrate many parallel tasks. Select instances 
#      with a high core count to maximize execution velocity.
# ==============================================================================
variable "instance_type" {
  type        = string
  default     = "t3.medium" # Default low-cost sandbox tier for local testing
  description = "EC2 instance size for executing processing workloads. See alignment sizing guidelines below."
}

# ------------------------------------------------------------------------------
# BIOINFORMATICS WORKLOAD SIZING ARCHITECTURE MAP
# (Pass these via terraform.tfvars or -var="instance_type=X" based on the lab run)
# ------------------------------------------------------------------------------
# TIER 1: Sandbox / Pipeline Dev Testing
#   - Size: "t3.medium" (2 vCPU, 4 GiB RAM) 
#   - Use-case: Testing Terraform logic, pipeline syntax, and small shell scripts.
#
# TIER 2: Whole Exome / High-Throughput Panel Processing
#   - Size: "c6i.4xlarge" (16 vCPU, 32 GiB RAM) or "m6i.4xlarge" (16 vCPU, 64 GiB RAM)
#   - Use-case: Standard BWA-MEM alignment loops for targeted gene panels.
#
# TIER 3: Production Whole Genome Sequencing (WGS) Alignment
#   - Size: "c6i.16xlarge" (64 vCPU, 128 GiB RAM) or "r6i.8xlarge" (32 vCPU, 256 GiB RAM)
#   - Use-case: Deep raw alignment jobs where large genomic indices must reside entirely in RAM.
# ------------------------------------------------------------------------------
