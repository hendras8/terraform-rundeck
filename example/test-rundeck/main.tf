terraform {
  required_version = "~> 0.14"
  backend "gcs" {
    bucket = "bucket-tf"
    prefix = "state/rundeck/test/test-rundeck/"
  }
}

variable "rundeck_token" {
  default = ""
}

module "rundeck" {
  source = "../../module/rundeck-module/"

  # SERVER RUNDECK
  rundeck_url   = "http://IP_RUNDECK:4440/"
  rundeck_token = var.rundeck_token 

  # RUNDECK PROJECT
  rundeck_project_name     = "testing-rundeck"
  rundeck_project_desc     = "testing-rundeck project created by terraform"
  rundeck_project_label    = "testing-rundeck"
  resource_type            = "file"
  rundeck_project_key_path = "keys/project/testing-rundeck/"

# RUNDECK EXECUTION RETENTION
  cleanup_enabled                = "false"
  cleanup_batch                  = "2000"
  cleanup_keep_days              = "30"
  cleanup_retention_minimum      = "20"
  cleanup_schedule               = "0 0 0 1/1 * ? *" # --> scheduler time for clean up execution history

  # JOB USING INLINE SCRIPT
  rundeck_jobs_inline = [
    {
      name                      = "testing-job-1"
      rundeck_group_name        = "test/job1"
      rundeck_schedule_enabled  = "true"
      rundeck_execution_enabled = "true"
      rundeck_job_desc          = "testing job scheduler"
      rundeck_job_timezone      = "Asia/Jakarta"
      rundeck_schedule          = "0 * * * * * *"
      rundeck_inline_script     = <<-EOF
 curl --fail -X GET 'https://blablabla.com/testing/api/v1'
 EOF
    },
    {
      name                      = "testing-job-2"
      rundeck_group_name        = "test/job2"
      rundeck_schedule_enabled  = "true"
      rundeck_execution_enabled = "true"
      rundeck_job_desc          = "testing job scheduler"
      rundeck_job_timezone      = "Asia/Jakarta"
      rundeck_schedule          = "0 * * * * * *"
      rundeck_inline_script     = <<-EOF
 curl --fail -X GET 'https://blablabla.com/testing/api/v2'
 EOF
    },

  ]

  # JOB USING COMMAND
  rundeck_jobs_command = [
      {
        name                      = "testing-job-command-1"
        rundeck_group_name        = "test/job1"
        rundeck_schedule_enabled  = "false"
        rundeck_execution_enabled = "false"
        rundeck_job_desc          = "job 3"
        rundeck_job_timezone      = "Asia/Jakarta"
        rundeck_schedule          = "0 8 * * * * *"
        rundeck_command_job       = "/usr/bin/curl icanhazip.com"
      }
  ]
}
