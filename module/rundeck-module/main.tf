terraform {
  required_providers {
    rundeck = {
      source  = "rundeck/rundeck"
      version = "0.4.3"
    }
  }
}

provider "rundeck" {
  url         = var.rundeck_url
  api_version = var.rundeck_api_version
  auth_token  = var.rundeck_token
}

resource "rundeck_project" "terraform" {
  name        = var.rundeck_project_name
  description = var.rundeck_project_desc
  ssh_key_storage_path = var.rundeck_project_key_path
    resource_model_source {
    type = "local"
    config = {
      #format = "resourcexml"
      # This path is interpreted on the Rundeck server.
      #file = "/var/lib/rundeck/resources.xml"
      writable = "true"
      generateFileAutomatically = "true"
    }
  }
  resource_model_source {
    type = var.resource_type
    config = {
      format = "resourcexml"
      # This path is interpreted on the Rundeck server.
      file = "/var/lib/rundeck/resources.xml"
      writable = "true"
      generateFileAutomatically = "true"
    }
  }
  extra_config = {
    "project/label" = var.rundeck_project_label
    "project/disable/executions"                          = "false"
    "project/disable/schedule"                            = "false"
    "project/execution/history/cleanup/batch"             = var.cleanup_batch
    "project/execution/history/cleanup/enabled"           = var.cleanup_enabled
    "project/execution/history/cleanup/retention/days"    = var.cleanup_keep_days
    "project/execution/history/cleanup/retention/minimum" = var.cleanup_retention_minimum
    "project/execution/history/cleanup/schedule"          = var.cleanup_schedule
    "project/jobs/gui/groupExpandLevel"                   = "1"
    "project/later/executions/disable"                    = "false"
    "project/later/executions/enable"                     = "false"
    "project/later/schedule/disable"                      = "false"
    "project/later/schedule/enable"                       = "false"
    "project/output/allowUnsanitized"                     = "false"
    "project/ssh-command-timeout"                         = "0"
    "project/ssh-connect-timeout"                         = "0"
  }
}

locals {

rundeck_job_name_inline = [for ap in toset(var.rundeck_jobs_inline) : ap.name]
rundeck_jobs_inline = zipmap(local.rundeck_job_name_inline, tolist(toset(var.rundeck_jobs_inline)))

rundeck_job_name_command = [for ap in toset(var.rundeck_jobs_command) : ap.name]
rundeck_jobs_command = zipmap(local.rundeck_job_name_command, tolist(toset(var.rundeck_jobs_command)))

}

resource "rundeck_job" "job_inline" {
  for_each          = local.rundeck_jobs_inline
  name              = each.key
  project_name      = rundeck_project.terraform.name
  group_name        = lookup(each.value, "rundeck_group_name", " ")
  node_filter_query = ".*"
  schedule_enabled  = lookup(each.value, "rundeck_schedule_enabled", "true")
  execution_enabled = lookup(each.value, "rundeck_execution_enabled", "true")
  description       = lookup(each.value, "rundeck_job_desc", "cron job")
  time_zone         = lookup(each.value, "rundeck_job_timezone", "Asia/Jakarta")
  #continue_next_node_on_error = lookup(each.value, "rundeck_continue_next_node_on_error", "")
  schedule          = lookup(each.value, "rundeck_schedule", " ")

  command {
    inline_script = lookup(each.value, "rundeck_inline_script", " ")
  } 
}

resource "rundeck_job" "job_command" {
  for_each          = local.rundeck_jobs_command
  name              = each.key
  project_name      = rundeck_project.terraform.name
  group_name        = lookup(each.value, "rundeck_group_name", " ")
  node_filter_query = ".*"
  schedule_enabled  = lookup(each.value, "rundeck_schedule_enabled", "true")
  execution_enabled = lookup(each.value, "rundeck_execution_enabled", "true")
  description       = lookup(each.value, "rundeck_job_desc", "cron job")
  time_zone         = lookup(each.value, "rundeck_job_timezone", "Asia/Jakarta")
  #continue_next_node_on_error = lookup(each.value, "rundeck_continue_next_node_on_error", "")
  schedule          = lookup(each.value, "rundeck_schedule", " ")

  command {
    shell_command  = lookup(each.value, "rundeck_command_job", " ")
  }
}
