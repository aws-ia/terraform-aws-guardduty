#####################################
# GuardDuty Organizations Admin     #
#####################################
resource "aws_guardduty_organization_admin_account" "this" {
  count            = var.admin_account_id == null ? 0 : 1
  admin_account_id = var.admin_account_id
}

resource "aws_guardduty_organization_configuration" "admin" {
  count = var.admin_account_id == null ? 0 : 1

  auto_enable                      = var.auto_enable_organization_members != null ? null : var.auto_enable_org_config
  auto_enable_organization_members = var.auto_enable_org_config != null ? null : var.auto_enable_organization_members
  detector_id                      = var.guardduty_detector_id

  datasources {
    s3_logs {
      auto_enable = var.enable_s3_protection
    }
    kubernetes {
      audit_logs {
        enable = var.enable_kubernetes_protection
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          auto_enable = var.enable_malware_protection
        }
      }
    }
  }
}