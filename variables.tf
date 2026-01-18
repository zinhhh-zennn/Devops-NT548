variable "region" { default = "ap-southeast-2" }
variable "my_ip_address" {
  description = "IP Public của bạn để SSH (ví dụ: 14.161.x.x/32)"
  type        = string
  default     = "0.0.0.0/0"
}
variable "key_pair_name" {
  description = "Tên KeyPair đã tạo trên AWS"
  type        = string
  default     = "key-pair"
}
