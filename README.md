# Azure Landing Zone

A production-inspired cloud infrastructure project built with Terraform, modeling the architecture patterns used in federal and enterprise Azure environments. Designed as a portfolio demonstration of infrastructure-as-code (IaC) skills targeting GovTech and DoD contracting roles.

---

## Overview

This project provisions a segmented Azure network environment with a containerized RHEL workload and remote Terraform state management. It mirrors real-world landing zone patterns used in FedRAMP and DoD IL environments where network segmentation, least-privilege access, and auditability are non-negotiable.

**Stack:** Terraform · Azure · Azure Container Instances · RHEL UBI9 · Azure Storage (remote state)

---

## Architecture

```
Resource Group: alz-dev-rg (eastus2)
│
├── Virtual Network: alz-dev-vnet (10.0.0.0/16)
│   ├── public-subnet     (10.0.1.0/24)  — ingress/egress, future load balancer
│   ├── private-subnet    (10.0.2.0/24)  — workloads, no direct internet access
│   └── management-subnet (10.0.3.0/24)  — admin access, future bastion host
│
├── Network Security Group: alz-dev-nsg
│   └── Attached to private and management subnets
│
└── Azure Container Instance: alz-dev-aci
    └── RHEL UBI9 container
        └── Deployed into private subnet
```

### Design Decisions

**Three-subnet segmentation**

The VNet is split into public, private, and management subnets rather than a flat network. This mirrors DoD network architecture where workloads are isolated from internet-facing resources and administrative access lives on a dedicated segment. Building this pattern from the start makes the project representative of real federal deployments.

**Azure Container Instances instead of a VM**

The original design called for a RHEL VM in the private subnet. During deployment, the Azure free subscription had no approved VM quota in `eastus2` for any eligible SKU. Rather than halt the project, ACI was substituted it achieves the same goal (a RHEL workload running inside the private subnet) without requiring compute quota approval. ACI also reflects the shift toward container-based workloads in cloud-native federal architectures. The RHEL UBI9 image keeps the workload RHEL-aligned, relevant for environments that mandate RHEL for STIG compliance.

**Remote state in Azure Storage**

Terraform state is stored remotely in an Azure Storage Account with a dedicated container. This prevents state file loss, enables team collaboration, and mirrors how state is managed in production IaC pipelines.

**`prevent_deletion_if_contains_resources = false`**

Set on the resource group to allow clean teardown during iterative development. In a production environment this would be `true` to prevent accidental deletion of a populated resource group.

---

## Repository Structure

```
azure-landing-zone/
├── main.tf                  # Root module — wires together child modules
├── providers.tf             # AzureRM provider config
├── backend.tf               # Remote state (Azure Storage)
├── variables.tf             # Input variable declarations
├── terraform.tfvars         # Variable values (non-sensitive)
├── .gitignore               # Excludes .terraform/, *.tfstate, tfplan
│
└── modules/
    ├── networking/          # VNet, subnets, NSG
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── aci/                 # Azure Container Instance (RHEL UBI9)
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.3
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed and authenticated
- An active Azure subscription with ACI quota in your target region

---

## Planned Additions

| Module | Description | Status |
|--------|-------------|--------|
| `networking` | VNet, subnets, NSG | ✅ Complete |
| `aci` | RHEL UBI9 container workload | ✅ Complete |
| `keyvault` | Azure Key Vault for secrets management | 🔲 Planned |
| `monitoring` | Log Analytics workspace + Azure Monitor | 🔲 Planned |

---

## Relevance to Federal Cloud Environments

This project was designed to reflect patterns seen in FedRAMP Moderate and DoD IL2/IL4 environments:

- **Network segmentation** aligns with NIST 800-53 SC-7 (Boundary Protection)
- **Remote state management** supports auditability and change tracking
- **RHEL-based workloads** reflect STIG-compliant OS preferences in DoD environments
- **Modular IaC structure** mirrors how landing zones are managed at scale in contractor environments

---

## Skills Demonstrated

| Category | Skills |
|----------|--------|
| **Infrastructure as Code** | Terraform modules, remote state, variable management, provider configuration |
| **Azure Networking** | Virtual Networks, subnets, Network Security Groups, subnet associations |
| **Compute** | Azure Container Instances, RHEL UBI9, container networking in private subnets |
| **State Management** | Remote backend configuration with Azure Blob Storage |
| **Security** | Network segmentation, NSG rule design, least-privilege subnet architecture |
| **DevOps Practices** | Modular IaC structure, `.gitignore` hygiene, iterative infrastructure development |
| **Federal Cloud Patterns** | FedRAMP/DoD IL architecture design, NIST 800-53 alignment, STIG-aware workload selection |

---

## Author

**Isaiah Tomlin**  
IT Systems Administrator | CompTIA Security+ CE | Public Trust Clearance  
Targeting cloud engineering roles in GovTech and DoD contracting  
[LinkedIn](https://www.linkedin.com/in/isaiah-tomlin-3a23aa202/)· [GitHub](https://github.com/CPUZ21)
