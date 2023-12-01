resource "azurerm_api_management_authorization_server" "auth_server" {
  name                         = var.name                             #""
  api_management_name          = var.api_management_name              #""
  resource_group_name          = var.resource_group_name              #""
  display_name                 = var.display_name                     #""
  authorization_endpoint       = "${var.auth_endpoint}/oauth2/default/v1/authorize"      #"https://fdbvelaidentitynp.okta.com/oauth2/default/v1/authorize"
  client_id                    = var.client_id                        #""
  client_secret                = var.client_secret                    #"" 
  client_registration_endpoint = var.auth_endpoint                    #"https://fdbvelaidentitynp.okta.com"
  token_endpoint               = "${var.auth_endpoint}/oauth2/default/v1/token"                    #"https://fdbvelaidentitynp.okta.com/oauth2/default/v1/token"  
  client_authentication_method = var.client_authentication_method     #
  bearer_token_sending_methods = var.bearer_token_sending_methods     #
  default_scope                = var.default_scope                    #"" 
  grant_types                  = var.grant_types                      #
  authorization_methods        = var.authorization_methods            #
}