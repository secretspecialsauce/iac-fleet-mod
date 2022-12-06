terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

locals {
  service_accounts = {
    "abm-gcr-agent-${var.cluster_name}" = {
      description : "ABM GCR Agent Account",
      roles : [
        "roles/storage.objectViewer"
      ]
    },
    "abm-gke-connect-agent-${var.cluster_name}" = {
      description : "ABM GKE Connect Agent Service Account",
      roles : [
        "roles/gkehub.connect"
      ]
    },
    "abm-gke-register-agent-${var.cluster_name}" = {
      description : "ABM GKE Connect Register Account",
      roles : [
        "roles/gkehub.admin"
      ]
    },
    "acm-monitoring-agent-${var.cluster_name}" = {
      description : "ACM Monitoring Account",
      roles : [
        "roles/monitoring.metricWriter"
      ]
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