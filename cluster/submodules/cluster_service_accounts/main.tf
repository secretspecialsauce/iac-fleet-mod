terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}


locals {
  service_accounts = {
    "abm-gcr-${var.cluster_name}" = {
      description : "ABM GCR Agent Account",
      roles : [
        "roles/storage.objectViewer"
      ],
      project_id : var.fleet_project_id
    },
    "abm-gke-con-${var.cluster_name}" = {
      description : "ABM GKE Connect Agent Service Account",
      roles : [
        "roles/gkehub.connect"
      ],
      project_id : var.fleet_project_id
    },
    "abm-gke-reg-${var.cluster_name}" = {
      description : "ABM GKE Connect Register Account",
      roles : [
        "roles/gkehub.admin"
      ],
      project_id : var.fleet_project_id
    },
    "acm-mon-${var.cluster_name}" = {
      description : "ACM Monitoring Account",
      roles : [
        "roles/monitoring.metricWriter"
      ],
      project_id : var.fleet_project_id
    },
    "abm-ops-${var.cluster_name}" = {
      description : "ABM Cloud Operations Service Account",
      roles : [
        "roles/logging.logWriter",
        "roles/monitoring.metricWriter",
        "roles/stackdriver.resourceMetadata.writer",
        "roles/monitoring.dashboardEditor",
        "roles/opsconfigmonitoring.resourceMetadata.writer"
      ],
      project_id : var.fleet_project_id
    },
    "es-k8s-${var.cluster_name}" = {
      description : "External Secrets Service Account",
      roles : [
        "roles/secretmanager.secretAccessor",
        "roles/secretmanager.viewer"
      ],
      project_id : var.secrets_project_id
    },
    "sds-backup-${var.cluster_name}" = {
      description : "SDS agent taking volume backups on cloud storage",
      roles : [],
      project_id : var.sds_project_id
    },
    "gtw-con-${var.cluster_name}" = {
      description : "Agent used for Gateway Connect",
      roles : [
        "roles/gkehub.gatewayAdmin",
        "roles/gkehub.viewer"
      ]
      project_id : var.fleet_project_id
    },
    "cdi-import-${var.cluster_name}" = {
      description : "Agent used for CDI image access",
      roles : [
        "roles/storage.objectViewer"
      ],
      project_id : var.fleet_project_id
    },
    "storage-${var.cluster_name}" = {
      description : "Agent used for Snapshot Cloud Storage",
      roles : [
        "roles/storage.admin"
      ],
      project_id : var.sds_project_id
    }
  }
}