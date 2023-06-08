variable "auth_token" {
  description = "Yandex OAuth token"
  type        = string
  default     = "XXXXXX"
}

variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
  default     = "XXXXXX"
}

variable "folder_id" {
  description = "Default folder ID"
  type        = string
  default     = "XXXXXX"
}

variable "zone" {
  description = "Geo zone ID"
  type        = string
  default     = "ru-central1-a"
}
