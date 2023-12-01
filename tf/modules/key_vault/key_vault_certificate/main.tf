resource "azurerm_key_vault_certificate" "keyvault_cert" {
  count        = var.create_apim_certificate ? 1 : 0
  name         = var.apim_certificate_name
  key_vault_id = var.key_vault_id

  certificate_policy {
    issuer_parameters {
      name = var.cert_issuer_name
    }

    key_properties {
      exportable = var.cert_key_export
      key_type   = var.cert_key_type
      reuse_key  = var.cert_reuse_key
      key_size = var.cert_key_size
    }

    secret_properties {
      content_type = var.cert_content_type
    }

    x509_certificate_properties {

      key_usage = var.key_usage

      subject            = var.cert_subject 
      validity_in_months = var.cert_validity
    }
  }
}