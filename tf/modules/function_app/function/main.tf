resource "azurerm_function_app_function" "availability" {
  name            = var.function_name
  function_app_id = var.function_app_id
  language        = var.function_language
  
  config_json = jsonencode({
    "bindings" = [
      {
        "authLevel" = "Anonymous"
        "direction" = "in"
        "methods" = [
          "get",
          "post",
        ]
        "name" = "Request"
        "type" = "httpTrigger"
      },
      {
        "direction" = "out"
        "name"      = "Response"
        "type"      = "http"
      },
    ]
  })
}