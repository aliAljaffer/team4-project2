resource "azurerm_monitor_autoscale_setting" "fe_autoscale" {
  name                = "team4-project2-fe-autoscale"
  resource_group_name = var.rg_name
  location            = var.rg_location
  target_resource_id  = var.fe_sp_id

  profile {
    name = "defaultProfile"

    capacity {
      default = 1
      minimum = 1
      maximum = 3
    }


    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = var.fe_sp_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = var.autoscale_cpu_threshold_high
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }


    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = var.fe_sp_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = var.autoscale_cpu_threshold_low
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }


    rule {
      metric_trigger {
        metric_name        = "MemoryPercentage"
        metric_resource_id = var.fe_sp_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 80
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = false
      send_to_subscription_co_administrator = false
      custom_emails                         = [local.autoscale_notification_email]
    }
  }

  tags = {
    Environment = "production"
    Tier        = "frontend"
    ManagedBy   = "Terraform"
  }
}

# Backend App Service Plan Autoscaling
resource "azurerm_monitor_autoscale_setting" "be_autoscale" {
  name                = "team4-project2-be-autoscale"
  resource_group_name = var.rg_name
  location            = var.rg_location
  target_resource_id  = var.be_sp_id

  profile {
    name = "defaultProfile"

    capacity {
      default = 1
      minimum = 1
      maximum = 3
    }


    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = var.be_sp_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = var.autoscale_cpu_threshold_high
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }


    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = var.be_sp_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = var.autoscale_cpu_threshold_low
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }


    rule {
      metric_trigger {
        metric_name        = "MemoryPercentage"
        metric_resource_id = var.be_sp_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 80
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }


    rule {
      metric_trigger {
        metric_name        = "HttpQueueLength"
        metric_resource_id = var.be_sp_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 100
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = false
      send_to_subscription_co_administrator = false
      custom_emails                         = [local.autoscale_notification_email]
    }
  }

  tags = {
    Environment = "production"
    Tier        = "backend"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${var.resource_prefix}-log-analytics"
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"

}

# Application Insights (shared for both fe and be)
resource "azurerm_application_insights" "insights" {
  name                = "${var.resource_prefix}-insights"
  location            = var.rg_location
  resource_group_name = var.rg_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.log_analytics.id
  retention_in_days   = 30
  sampling_percentage = 100
  disable_ip_masking  = false
}

# Diagnostic Settings for Frontend Web App
resource "azurerm_monitor_diagnostic_setting" "frontend_diag" {
  name                       = "${var.resource_prefix}-frontend-diag"
  target_resource_id         = var.frontend_app_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }
  enabled_log {
    category = "AppServiceConsoleLogs"
  }
  enabled_log {
    category = "AppServiceAppLogs"
  }
  enabled_metric {
    category = "AllMetrics"
  }
}

# Diagnostic Settings for Backend Web App
resource "azurerm_monitor_diagnostic_setting" "backend_diag" {
  name                       = "${var.resource_prefix}-backend-diag"
  target_resource_id         = var.backend_app_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics.id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }
  enabled_log {
    category = "AppServiceConsoleLogs"
  }
  enabled_log {
    category = "AppServiceAppLogs"
  }
  enabled_metric {
    category = "AllMetrics"
  }
}

# Action Group for Alerts
resource "azurerm_monitor_action_group" "action_group" {
  name                = "${var.resource_prefix}-action-group"
  resource_group_name = var.rg_name
  short_name          = "alerts"
  enabled             = true

  email_receiver {
    name          = "email"
    email_address = var.admin_email
  }
}

# Alert 1: App Gateway Backend Health <100% for 5 min
resource "azurerm_monitor_metric_alert" "appgw_health" {
  name                = "${var.resource_prefix}-appgw-health-alert"
  resource_group_name = var.rg_name
  scopes              = [var.app_gateway_id]
  description         = "App Gateway Backend Health <100% for 5 min"
  severity            = 3
  frequency           = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "BackendResponseStatus"
    aggregation      = "Total"
    operator         = "LessThan"
    threshold        = 100
  }

  action {
    action_group_id = azurerm_monitor_action_group.action_group.id
  }
}

# Alert 2: frontend Web App CPU >70% for 5 min
resource "azurerm_monitor_metric_alert" "frontend_cpu" {
  name                = "${var.resource_prefix}-frontend-cpu-alert"
  resource_group_name = var.rg_name
  scopes              = [var.fe_sp_id]
  description         = "Frontend Web App CPU >70% for 5 min"
  severity            = 3
  frequency           = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Web/serverfarms"
    metric_name      = "CpuPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 70
  }

  action {
    action_group_id = azurerm_monitor_action_group.action_group.id
  }
}

# Alert 2 : Backend Web App CPU >70% for 5 min
resource "azurerm_monitor_metric_alert" "backend_cpu" {
  name                = "${var.resource_prefix}-backend-cpu-alert"
  resource_group_name = var.rg_name
  scopes              = [var.be_sp_id]
  description         = "Backend Web App CPU >70% for 5 min"
  severity            = 3
  frequency           = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Web/serverfarms"
    metric_name      = "CpuPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 70
  }

  action {
    action_group_id = azurerm_monitor_action_group.action_group.id
  }
}

# Alert 3: SQL DTU Utilization >80%
# resource "azurerm_monitor_metric_alert" "sql_dtu" {
#   name                = "${var.resource_prefix}-sql-dtu-alert"
#   resource_group_name = var.rg_name
#   scopes              = [azurerm_mssql_database.sql_database.id]
#   description         = "SQL DTU Utilization >80%"
#   severity            = 3
#   frequency           = "PT5M"

#   criteria {
#     metric_namespace = "Microsoft.Sql/servers/databases"
#     metric_name      = "dtu_consumption_percent"
#     aggregation      = "Average"
#     operator         = "GreaterThan"
#     threshold        = 80
#   }

#   action {
#     action_group_id = azurerm_monitor_action_group.action_group.id
#   }
# }

# # Autoscaling for Frontend App Service Plan
# resource "azurerm_monitor_autoscale_setting" "asp_autoscale_frontend" {
#   name                = "${var.resource_prefix}-autoscale-frontend"
#   resource_group_name = var.rg_name
#   location            = var.location
#   target_resource_id  = azurerm_service_plan.app_service_plan_frontend.id
#   enabled             = true

#   profile {
#     name = "defaultProfile"

#     capacity {
#       default = 1
#       minimum = 1
#       maximum = 4
#     }

#     rule {
#       metric_trigger {
#         metric_name        = "CpuPercentage"
#         metric_resource_id = azurerm_service_plan.app_service_plan_frontend.id
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_aggregation   = "Average"
#         time_window        = "PT10M"
#         threshold          = 60
#         operator           = "GreaterThan"
#       }
#       scale_action {
#         direction = "Increase"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }
#     }

#     rule {
#       metric_trigger {
#         metric_name        = "CpuPercentage"
#         metric_resource_id = azurerm_service_plan.app_service_plan_frontend.id
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_aggregation   = "Average"
#         time_window        = "PT10M"
#         threshold          = 20
#         operator           = "LessThan"
#       }
#       scale_action {
#         direction = "Decrease"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }
#     }
#   }

#   notification {
#     email {
#       custom_emails = [var.admin_email]
#     }
#   }
# }

# # Autoscaling for Backend App Service Plan
# resource "azurerm_monitor_autoscale_setting" "asp_autoscale_backend" {
#   name                = "${var.resource_prefix}-autoscale-backend"
#   resource_group_name = var.rg_name
#   location            = var.location
#   target_resource_id  = azurerm_service_plan.app_service_plan_backend.id
#   enabled             = true

#   profile {
#     name = "defaultProfile"

#     capacity {
#       default = 1
#       minimum = 1
#       maximum = 4
#     }

#     rule {
#       metric_trigger {
#         metric_name        = "CpuPercentage"
#         metric_resource_id = azurerm_service_plan.app_service_plan_backend.id
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_aggregation   = "Average"
#         time_window        = "PT10M"
#         threshold          = 60
#         operator           = "GreaterThan"
#       }
#       scale_action {
#         direction = "Increase"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }
#     }

#     rule {
#       metric_trigger {
#         metric_name        = "CpuPercentage"
#         metric_resource_id = azurerm_service_plan.app_service_plan_backend.id
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_aggregation   = "Average"
#         time_window        = "PT10M"
#         threshold          = 20
#         operator           = "LessThan"
#       }
#       scale_action {
#         direction = "Decrease"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }
#     }
#   }

#   notification {
#     email {
#       custom_emails = [var.admin_email]
#     }
#   }
# }
