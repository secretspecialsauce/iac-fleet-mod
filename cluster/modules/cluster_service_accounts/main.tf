terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

variable "gsa_gcr_agent_project" {}
variable "gsa_abm_gke_connect_agent_project" {}

variable "gsa_abm_gke_register_agent_project" {
  default = ""
}
locals {
  service_accounts = {
    "abm-gcr-agent-${var.cluster_name}" = {
      description : "ABM GCR Agent Account",
      roles : [
        "roles/storage.objectViewer"
      ],
      project_id: var.gsa_gcr_agent_project
    },
    "abm-gke-connect-agent-${var.cluster_name}" = {
      description : "ABM GKE Connect Agent Service Account",
      roles : [
        "roles/gkehub.connect"
      ],
      project_id: var.gsa_abm_gke_connect_agent_project
    },
    "abm-gke-register-agent-${var.cluster_name}" = {
      description : "ABM GKE Connect Register Account",
      roles : [
        "roles/gkehub.admin"
      ],
      project_id: var.gsa_abm_gke_register_agent_project
    },
    "acm-monitoring-agent-${var.cluster_name}" = {
      description : "ACM Monitoring Account",
      roles : [
        "roles/monitoring.metricWriter"
      ],
      project_id: var.gsa_
    },
    "abm-ops-agent-${var.cluster_name}" = {
      description : "ABM Cloud Operations Service Account",
      roles : [
        "roles/logging.logWriter",
        "roles/monitoring.metricWriter",
        "roles/stackdriver.resourceMetadata.writer",
        "roles/monitoring.dashboardEditor",
        "roles/opsconfigmonitoring.resourceMetadata.writer"
      ]
    },
    "external-secrets-k8s-${var.cluster_name}" = {
      description : "External Secrets Service Account",
      roles : [
        "roles/secretmanager.secretAccessor",
        "roles/secretmanager.viewer"
      ]
    },
    "longhorn-cloud-storage-${var.cluster_name}" = {
      description : "Longhorn taking volume backups on cloud storage ",
      roles : [
        "roles/storage.objectAdmin"
      ]
    },
    "source-repo-agent-${var.cluster_name}" = {
      description : "Agent used for GSR",
      roles : [
        "roles/source.reader"
      ]
    },
    "cdi-import-agent-${var.cluster_name}" = {
      description : "Agent used for CDI image access",
      roles : [
        "roles/storage.objectViewer"
      ]
    },
    "storage-agent-${var.cluster_name}" = {
      description : "Agent used for Snapshot Cloud Storage",
      roles : [
        "roles/storage.admin"
      ]
    }
  }
}