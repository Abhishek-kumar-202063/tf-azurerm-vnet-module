# tf-azurerm-vnet-module

A production-ready Terraform module for deploying Azure Virtual Networks with consistent naming, governance tags, and optional Management Locks.

---

## Name Format

```
vnet-{location_code}-{environment}-{name}
```

### Examples

| `location`    | `environment` | `name`    | Generated Name               |
|---------------|---------------|-----------|------------------------------|
| `East US 2`   | `prod`        | `hub`     | `vnet-eus2-prod-hub`         |
| `West US 3`   | `dev`         | `spoke01` | `vnet-wus3-dev-spoke01`      |
| `UK South`    | `staging`     | `dmz`     | `vnet-uks-staging-dmz`       |
| `Canada East` | `uat`         | `mgmt`    | `vnet-cae-uat-mgmt`          |

---

## Usage

### Development (no lock)

```hcl
module "vnet_dev" {
  source = "git::https://github.com/your-org/tf-azurerm-vnet-module.git?ref=v1.0.0"

  name                = "spoke01"
  location            = "East US 2"
  environment         = "dev"
  resource_group_name = "rg-eus2-dev-networking"
  address_space       = ["10.10.0.0/16"]
}
```

### Production (with lock)

```hcl
module "vnet_prod" {
  source = "git::https://github.com/your-org/tf-azurerm-vnet-module.git?ref=v1.0.0"

  name                = "hub"
  location            = "East US 2"
  environment         = "prod"
  resource_group_name = "rg-eus2-prod-networking"
  address_space       = ["10.0.0.0/8"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    cost_center = "platform"
    owner       = "network-team"
  }

  enable_lock = true
  lock_level  = "CanNotDelete"
}
```

---

## Inputs

### Required

| Name                  | Type           | Description                                                     |
|-----------------------|----------------|-----------------------------------------------------------------|
| `name`                | `string`       | Name identifier. Generates: `vnet-<location>-<env>-<name>`.    |
| `location`            | `string`       | Azure region. Must be a value from the supported locations list.|
| `environment`         | `string`       | Deployment environment. Example: `dev`, `uat`, `prod`.          |
| `resource_group_name` | `string`       | Resource Group where the Virtual Network will be deployed.      |
| `address_space`       | `list(string)` | CIDR blocks for the VNet address space. E.g. `["10.0.0.0/16"]`.|

### Optional

| Name          | Type           | Default | Description                                                              |
|---------------|----------------|---------|--------------------------------------------------------------------------|
| `dns_servers` | `list(string)` | `[]`    | Custom DNS server IPs. Empty list uses Azure default DNS.                |
| `tags`        | `map(string)`  | `{}`    | Additional tags. Governance tags (`environment`, `managed_by`) are always applied. |

### Lock Section

| Name          | Type     | Default          | Description                                                      |
|---------------|----------|------------------|------------------------------------------------------------------|
| `enable_lock` | `bool`   | `false`          | Enable Azure Management Lock. Recommended for production.        |
| `lock_level`  | `string` | `"CanNotDelete"` | Lock level: `CanNotDelete` or `ReadOnly`.                        |
| `lock_name`   | `string` | `null`           | Custom lock name. Defaults to `<vnet-name>-lock` when not set.  |

---

## Outputs

| Name           | Description                                                      |
|----------------|------------------------------------------------------------------|
| `name`         | Generated Virtual Network name.                                  |
| `id`           | Azure Resource ID of the Virtual Network.                        |
| `location`     | Azure region of the Virtual Network.                             |
| `address_space`| Address space CIDR blocks of the Virtual Network.                |
| `resource`     | Full `azurerm_virtual_network` resource object.                  |
| `lock_id`      | Resource ID of the Management Lock. `null` if `enable_lock = false`. |

---

## Supported Locations

| Azure Region          | Code     |
|-----------------------|----------|
| East US               | `eus`    |
| East US 2             | `eus2`   |
| West US               | `wus`    |
| West US 2             | `wus2`   |
| West US 3             | `wus3`   |
| Central US            | `cus`    |
| North Central US      | `ncus`   |
| South Central US      | `scus`   |
| West Central US       | `wcus`   |
| North Europe          | `neu`    |
| West Europe           | `weu`    |
| UK South              | `uks`    |
| UK West               | `ukw`    |
| France Central        | `frc`    |
| Germany West Central  | `gwc`    |
| Switzerland North     | `swn`    |
| Norway East           | `noe`    |
| Sweden Central        | `sec`    |
| UAE North             | `uaen`   |
| Australia East        | `aue`    |
| Australia Southeast   | `ause`   |
| Japan East            | `jpe`    |
| Japan West            | `jpw`    |
| Korea Central         | `krc`    |
| Southeast Asia        | `sea`    |
| East Asia             | `ea`     |
| Central India         | `cin`    |
| South India           | `sin`    |
| West India            | `win`    |
| Jio India West        | `jiowin` |
| Brazil South          | `brs`    |
| Canada Central        | `cac`    |
| Canada East           | `cae`    |

---

## Requirements

| Name        | Version               |
|-------------|-----------------------|
| Terraform   | `>= 1.2.0, < 2.0.0`  |
| AzureRM     | `>= 3.0.0, < 5.0.0`  |

---

## Versioning

This module follows [Semantic Versioning](https://semver.org/).

| Version | Description           |
|---------|-----------------------|
| `1.x`   | AzureRM 3.x / 4.x    |

Pin to a specific release tag to avoid unintended breaking changes:

```hcl
source = "git::https://github.com/your-org/tf-azurerm-vnet-module.git?ref=v1.0.0"
```

---

## License

Apache 2.0 — see [LICENSE](LICENSE) for details.
