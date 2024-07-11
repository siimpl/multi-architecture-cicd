variable "github_config" {
    type = object({
      config_url = string
      pat = string
    })
}