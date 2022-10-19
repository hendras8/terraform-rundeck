variable "resource_type" {
    default = "local"
}

variable "rundeck_project_name" {
    default = ""
}

variable "rundeck_project_desc" {
    default = ""
}

variable "rundeck_project_label" {
    default = ""
}

variable "rundeck_project_key_path" {
    default = ""
}

variable "rundeck_url" {
    default = ""
}

variable "rundeck_token" {
    default = ""
}

variable "rundeck_api_version" {
    default = "38"
}

variable "rundeck_jobs_inline" {
  type = list(map(string))
}

variable "rundeck_jobs_command" {
  type = list(map(string))
}

variable "rundeck_job_name" {
    default = ""
}

variable "rundeck_group_name" {
    default = ""
}

variable "rundeck_schedule_enabled" {
    default = "true"
}

variable "rundeck_execution_enabled" {
    default = "true"
}

variable "rundeck_job_desc" {
    default = ""
}

variable "rundeck_job_timezone" {
    default = ""
}

variable "rundeck_schedule" {
    default = ""
}

variable "rundeck_command_job" {
    default = ""
}

variable "rundeck_inline_script" {
    default = ""
}

#variable "rundeck_continue_next_node_on_error" {
#    default = ""
#}

variable "cleanup_batch" {
    default = "500"
}

variable "cleanup_keep_days" {
    default = "60"
}

variable "cleanup_retention_minimum" {
    default = "50"
}

variable "cleanup_schedule" {
    default = "0 0 0 1/1 * ? *"
}

variable "cleanup_enabled" {
    default = "false"
}
