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
      project_id : var.gsa_gcr_agent_iam_project
    },
    "abm-gke-con-${var.cluster_name}" = {
      description : "ABM GKE Connect Agent Service Account",
      roles : [
        "roles/gkehub.connect"
      ],
      project_id : var.gsa_abm_gke_connect_agent_iam_project
    },
    "abm-gke-reg-${var.cluster_name}" = {
      description : "ABM GKE Connect Register Account",
      roles : [
        "roles/gkehub.admin"
      ],
      project_id : var.gsa_abm_gke_register_agent_iam_project
    },
    "acm-mon-${var.cluster_name}" = {
      description : "ACM Monitoring Account",
      roles : [
        "roles/monitoring.metricWriter"
      ],
      project_id : var.gsa_acm_monitoring_agent_iam_project
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
      project_id : var.gsa_abm_ops_agent_iam_project
    },
    "es-k8s-${var.cluster_name}" = {
      description : "External Secrets Service Account",
      roles : [
        "roles/secretmanager.secretAccessor",
        "roles/secretmanager.viewer"
      ],
      project_id : var.gsa_external_secrets_iam_project
    },
    "sds-backup-${var.cluster_name}" = {
      description : "SDS agent taking volume backups on cloud storage",
      roles : [
        "roles/storage.objectAdmin"
      ],
      project_id : var.gsa_sds_backup_agent_iam_project
    },
    "gtw-con-${var.cluster_name}" = {
      description : "Agent used for Gateway Connect",
      roles : [
        "roles/gkehub.gatewayAdmin",
        "roles/gkehub.viewer"
      ]
      project_id : var.gsa_gateway_connect_agent_iam_project
    }
    "src-repo-${var.cluster_name}" = {
      description : "Agent used for GSR",
      roles : [
        "roles/source.reader"
      ],
      project_id : var.gsa_source_repo_agent_iam_project
    },
    "cdi-import-${var.cluster_name}" = {
      description : "Agent used for CDI image access",
      roles : [
        "roles/storage.objectViewer"
      ],
      project_id : var.gsa_cdi_import_agent_iam_project
    },
    "storage-${var.cluster_name}" = {
      description : "Agent used for Snapshot Cloud Storage",
      roles : [
        "roles/storage.admin"
      ],
      project_id : var.gsa_storage_agent_iam_project
    }
  }
}