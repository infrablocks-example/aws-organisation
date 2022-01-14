module "organization" {
  source  = "infrablocks/organization/aws"
  version = "1.0.0"

  organizational_units = [
    {
      name = "Example Product",
      children = [
        {
          name = "Management",
          children = []
        },
        {
          name = "Development",
          children = []
        },
        {
          name = "Production",
          children = []
        }
      ]
    }
  ]

  accounts = [
    {
      name = "Example Product Default"
      email = var.ibe_example_product_account_email
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
