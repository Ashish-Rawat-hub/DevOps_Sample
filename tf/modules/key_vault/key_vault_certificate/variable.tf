variable "create_apim_certificate" {
  description = "Bool to decide whether to create certificate or not"
  default = false
}

variable "key_vault_id" {
  description = "key vault id where the certificate will be stored"
}

variable "apim_certificate_name" {
  description = "Certificate name to be created"
}

variable "cert_subject" {
  description = "Certificate Subject"
  default = "CN=https://{{prefix}}-{{env}}-webapp-{{postfix}}.azurewebsites.net"
}

variable "cert_validity" {
  description = "Certificate validity in months"
  default = 12
}

variable "key_usage" {
  description = "Certificate key usage list"
  default = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]
}

variable "cert_issuer_name" {
  description = " The name of the Certificate Issuer. "
  default = "Self"
}

variable "cert_key_export" {
  description = "Is this certificate exportable? "
  default = true
}

variable "cert_key_type" {
  description = "Specifies the type of key. Possible values are EC, EC-HSM, RSA, RSA-HSM and oct"
  default = "RSA"
}

variable "cert_reuse_key" {
  description = "Is the key reusable?"
  default = true
}

variable "cert_key_size" {
  description = "The size of the key used in the certificate."
  default = 2048
}

variable "cert_content_type" {
  description = "The Content-Type of the Certificate, such as application/x-pkcs12 for a PFX or application/x-pem-file for a PEM"
  default = "application/x-pkcs12"
}