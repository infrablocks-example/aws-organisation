module "organization" {
  source  = "infrablocks/organization/aws"
  version = "1.0.0"

  organizational_units = [
    {
      name = "InfraBlocks",
      children = [
        {
          name = "Example Product"
          children = [
            {
              name = "Management"
            },
            {
              name = "Development"
            },
            {
              name = "Production"
            }
          ]
        }
      ]
    }
  ]

  accounts = [
    {
      name = "InfraBlocks Default"
      email = var.ibe_parent_account_email
      organizational_unit = "InfraBlocks"
      allow_iam_users_access_to_billing = true
    },
    {
      name = "Example Product Default"
      email = var.ibe_parent_account_email
      organizational_unit = "Example Product"
      allow_iam_users_access_to_billing = true
    },
    {
      name = "Management Default"
      email = var.ibe_management_account_email
      organizational_unit = "Management"
      allow_iam_users_access_to_billing = true
    },
    {
      name = "Development Molybdenum"
      email = var.ibe_development_molybdenum_account_email
      organizational_unit = "Development"
      allow_iam_users_access_to_billing = true
    },
    {
      name = "Production Holmium"
      email = var.ibe_production_holmium_account_email
      organizational_unit = "Production"
      allow_iam_users_access_to_billing = true
    }
  ]
}
