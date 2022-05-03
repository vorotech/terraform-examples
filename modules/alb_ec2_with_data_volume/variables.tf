variable "env" {
  description = "Environment identifier."
  type        = string
}

variable "app" {
  description = "Resources namespace and cost-allocation tag."
  type        = string
}

variable "vpc_id" {
  description = "VPC identifier."
  type        = string
}

variable "availability_zone" {
  description = "Region availability zone."
  type        = string
}

variable "data_volume_create" {
  description = "Flag indicating whether to create data EBS volume."
  default     = false
  type        = bool
}

variable "data_volume_size" {
  description = "Data EBS volume size."
  type        = number
  default     = 40
}

variable "data_volume_type" {
  description = "Data EBS volume type."
  type        = string
  default     = "gp2"

  validation {
    condition     = contains(["standard", "gp2", "gp3", "io1", "io2", "sc1", "st1"], var.data_volume_type)
    error_message = "Can be standard, gp2, gp3, io1, io2, sc1 or st1."
  }
}

variable "root_volume_size" {
  description = "Root Block volume size."
  type        = number
  default     = 8
}

variable "instance_ami" {
  description = "EC2 instance AMI identifier."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  default     = "t3.micro"
}

variable "instance_key_name" {
  description = "EC2 key name."
  default     = null
  type        = string
}

variable "data_volume_attachment_device_name" {
  description = "Data EBS volume attachment device name."
  default     = "/dev/xvdg"
  type        = string
}

variable "instance_subnet_id" {
  description = "EC2 instance subnet."
  type        = string
}

variable "instance_ami_id" {
  description = "AMI to launch EC2 instance."
  default     = ""
  type        = string
}

variable "instance_associate_instance_profile" {
  description = "Flag indicating whether to associate instance profile containing an IAM role. `iam_role_name` should be specified."
  default     = false
  type        = bool
}

variable "iam_role_name" {
  description = "(Optional) IAM Role name use an EC2 Instance Profile."
  default     = null
  type        = string
}

variable "alb_subnet_ids" {
  description = "Application Load Balancer subnets."
  type        = list(string)
}

variable "alb_internal" {
  description = "Flag indicating whether ALB schema will be internal or internet-facing."
  default     = true
  type        = bool
}

variable "alb_access_logs_bucket" {
  description = "(Optional) S3 bucket name to setup ALB access logs storing."
  default     = ""
  type        = string
}

variable "alb_access_logs_prefix" {
  description = "(Optional) S3 bucket prefix to setup ALB access logs storing. Defaults to app variable."
  default     = ""
  type        = string
}

variable "alb_certificate_domain" {
  description = "(Optional) ACM certificate domain to configure ALB listener."
  default     = ""
  type        = string
}

variable "alb_listener_port" {
  description = "Application Load Balancer listener port."
  default     = 443
  type        = number
}

variable "alb_redirect_http" {
  description = "Flag indicating whether to redirect HTTP to HTTPS requests."
  default     = true
  type        = bool
}

variable "alb_target_port" {
  description = "Application Load Balancer target group port."
  default     = 80
  type        = number
}

variable "alb_target_protocol" {
  description = "Application Load Balancer target group protocol."
  default     = "HTTP"
  type        = string

  validation {
    condition     = contains(["GENEVE", "HTTP", "HTTPS", "TCP", "TCP_UDP", "TLS", "UDP"], var.alb_target_protocol)
    error_message = "Should be one of GENEVE, HTTP, HTTPS, TCP, TCP_UDP, TLS, or UDP."
  }
}

variable "alb_target_health_path" {
  description = "Application Load Balancer target group health check path."
  default     = "/"
  type        = string
}

variable "alb_sg_ids" {
  description = "List of security groups to attach to Application Load Balancer."
  default     = []
  type        = list(string)
}

variable "instance_sg_ids" {
  description = "List of security groups to attach to EC2 Instance."
  default     = []
  type        = list(string)
}

variable "tags" {
  default     = {}
  description = "Map of tags to be applied to all resources."
  type        = map(string)
}
