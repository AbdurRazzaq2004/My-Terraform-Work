<div align="center">

<img src="https://img.shields.io/badge/Terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform"/>
<img src="https://img.shields.io/badge/Azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white" alt="Azure"/>
<img src="https://img.shields.io/badge/HCL-%23430098.svg?style=for-the-badge&logo=hashicorp&logoColor=white" alt="HCL"/>
<img src="https://img.shields.io/badge/.NET-512BD4.svg?style=for-the-badge&logo=dotnet&logoColor=white" alt=".NET"/>

# 🔄 Mini Project 3

### App Service with Deployment Slots (Blue/Green Deployment)

<br/>

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=22&pause=1000&color=0078D4&center=true&vCenter=true&multiline=true&repeat=true&width=700&height=80&lines=Blue%2FGreen+Deployment+%7C+Zero+Downtime;App+Service+%2B+Staging+Slot+%2B+Slot+Swap" alt="Typing SVG" />

<br/>

<img src="https://img.shields.io/badge/Slots-2-blue?style=flat-square&logo=microsoftazure" alt="Slots"/>
<img src="https://img.shields.io/badge/Terraform-%3E%3D1.9.0-purple?style=flat-square&logo=terraform" alt="Terraform Version"/>
<img src="https://img.shields.io/badge/AzureRM-~%3E4.8.0-0078D4?style=flat-square&logo=microsoftazure" alt="AzureRM"/>
<img src="https://img.shields.io/badge/Status-Deployed%20%E2%9C%85-brightgreen?style=flat-square" alt="Status"/>

</div>

<br/>

---

<details>
<summary><b>⚠️ Playground Limitations (click to expand)</b></summary>

<br/>

This project was built using a **Cloud Playground (sandbox)** with **limited privileges**. The sandbox does **not** allow creating Resource Groups, registering Resource Providers, or creating Service Principals. Because of these restrictions, certain workarounds were applied across the Terraform files.

### What Was Changed and Why

| File | What Changed | Why |
|:---|:---|:---|
| `provider.tf` | `subscription_id` is explicitly set | The sandbox requires specifying the subscription ID manually |
| `provider.tf` | `resource_provider_registrations = "none"` | The sandbox does not allow registering Azure Resource Providers |
| `main.tf` | Uses `data "azurerm_resource_group"` (data source) instead of `resource "azurerm_resource_group"` | The sandbox does not allow creating new Resource Groups, so we reference the pre existing one |
| `output.tf` | Output references `data.azurerm_resource_group.rg.name` | Same reason — reading from data source instead of resource |
| `variables.tf` | Added `resource_group_name` variable | Needed to pass the pre existing Resource Group name |
| `terraform.tfvars` | Added `resource_group_name` value | Supplies the sandbox Resource Group name |

### If You Have a Personal Azure Account

If you are using a **personal Azure account** with full privileges, you can undo these workarounds:

1. **In `provider.tf`**: Remove `subscription_id` (Terraform will use your default) and remove `resource_provider_registrations = "none"` (Terraform will auto register providers)

2. **In `main.tf`**: Replace the data source with a resource block:
   ```hcl
   resource "azurerm_resource_group" "rg" {
     name     = "${var.prefix}-rg"
     location = var.location
     tags     = local.common_tags
   }
   ```

3. **In all files**: Change every reference from:
   - `data.azurerm_resource_group.rg.name` → `azurerm_resource_group.rg.name`
   - `data.azurerm_resource_group.rg.location` → `azurerm_resource_group.rg.location`

4. **In `variables.tf` and `terraform.tfvars`**: Remove the `resource_group_name` variable and its value (Terraform will create the RG for you)

</details>

---

## 📌 Overview

> This mini project demonstrates **Azure App Service Deployment Slots** and the **Blue/Green deployment strategy** — deploying a web application with a staging slot, then swapping it to production with zero downtime.

The project deploys an **Azure Linux Web App** with a **staging deployment slot**, each connected to different branches of a GitHub repository via **source control integration**. A boolean variable controls whether the **staging slot is swapped to production**, simulating a real world Blue/Green deployment.

```
        ┌─────────────────────────────────────────────────┐
        │              App Service Plan (S1)              │
        │                                                 │
        │  ┌──────────────────┐  ┌──────────────────┐    │
        │  │   Production     │  │   Staging Slot    │    │
        │  │   (master)       │  │   (feature branch)│    │
        │  │                  │  │                   │    │
        │  │  🔵 Blue         │  │  🟢 Green         │    │
        │  └──────────────────┘  └──────────────────┘    │
        │            ▲                    │               │
        │            │     Slot Swap      │               │
        │            └────────────────────┘               │
        └─────────────────────────────────────────────────┘
```

---

## 🤔 Why This Architecture?

<table>
<tr>
<td width="50%">

### 🌐 Why App Service?

Azure App Service is a **fully managed PaaS** for hosting web applications

- ✅ No infrastructure to manage (no VMs, no OS patching)
- ✅ Built in CI/CD with GitHub integration
- ✅ Auto scaling, custom domains, SSL certificates
- ✅ Supports .NET, Node.js, Python, Java, PHP, and more

</td>
<td width="50%">

### 🔄 Why Deployment Slots?

Deployment slots let you run **multiple versions** of your app simultaneously

- ✅ Test in staging before going live
- ✅ Each slot has its own URL and configuration
- ✅ Slots share the same App Service Plan resources
- ✅ Warm up new code before exposing it to users

</td>
</tr>
<tr>
<td width="50%">

### 🔵🟢 Why Blue/Green Deployment?

Blue/Green is a deployment strategy that provides **zero downtime releases**

- ✅ **Blue** = current production version
- ✅ **Green** = new version running in staging
- ✅ **Swap** = instant switch with no downtime
- ✅ **Rollback** = swap back if something goes wrong

</td>
<td width="50%">

### 📦 Why Source Control Integration?

Connecting slots to GitHub branches enables **automatic deployments**

- ✅ Push to `master` → production auto deploys
- ✅ Push to feature branch → staging auto deploys
- ✅ No manual file uploads or FTP needed
- ✅ Full traceability from commit to deployment

</td>
</tr>
</table>

---

## 🛠️ What This Project Deploys

<div align="center">

| # | Resource | Purpose |
|:---:|:---|:---|
| 1 | **Resource Group** | Container for all resources |
| 2 | **App Service Plan** | Linux Standard S1 plan (supports deployment slots) |
| 3 | **Linux Web App** | Production .NET web application |
| 4 | **Deployment Slot (Staging)** | Staging version of the web app |
| 5 | **Source Control (Production)** | GitHub integration — `master` branch |
| 6 | **Source Control (Staging)** | GitHub integration — feature branch |
| 7 | **Active Slot Swap** | Swaps staging to production (conditional) |

</div>

---

## 📁 File Structure

```bash
📦 Mini-Project-3(App Service with Deployment Slots)/
 ┣ 📄 provider.tf         # Provider configuration (AzureRM)
 ┣ 📄 backend.tf          # Remote state configuration
 ┣ 📄 variables.tf        # All input variables with validations
 ┣ 📄 terraform.tfvars    # Variable values
 ┣ 📄 local.tf            # Local values (common tags)
 ┣ 📄 main.tf             # App Service Plan, Web App, Slots, Source Control, Slot Swap
 ┣ 📄 output.tf           # Deployment outputs (URLs, names, swap status)
 ┣ 📄 .gitignore          # Ignore Terraform state files
 ┗ 📄 README.md           # This file
```

---

## 🔧 Terraform Concepts Used

> This mini project integrates concepts from previous lessons into a PaaS deployment.

| Concept | Where Used | Lesson |
|:---|:---|:---:|
| **Modular File Structure** | Separate .tf files for each concern | 3 |
| **Variable Validations** | SKU restricted to slot capable tiers, OS type validated | 4 |
| **Local Values** | Common tags applied to all resources | 4 |
| **Conditional Expressions** | `count = var.swap_slot_to_production ? 1 : 0` for slot swap | 7 |
| **depends_on** | Source control depends on web app and slot creation | 5 |
| **merge Function** | `merge(local.common_tags, { slot = "production" })` for slot specific tags | 8 |
| **Data Sources** | Reference existing Resource Group | 9 |
| **String Interpolation** | `"https://${azurerm_linux_web_app.webapp.default_hostname}"` in outputs | 7 |

---

## 🚀 How to Deploy

### Prerequisites

| Requirement | Version |
|:---|:---|
| Azure CLI | Authenticated (`az login`) |
| Terraform | >= 1.9.0 |

### Step 1 — Deploy Without Slot Swap

```bash
terraform init
terraform plan
terraform apply
```

### Step 2 — Visit Both URLs

```bash
# Production URL (Blue — master branch)
terraform output production_url

# Staging URL (Green — feature branch)
terraform output staging_url
```

Open both URLs in your browser — they should show **different content** (different branches).

### Step 3 — Swap Staging to Production (Blue/Green)

Update `terraform.tfvars`:

```hcl
swap_slot_to_production = true
```

Then apply:

```bash
terraform plan
terraform apply
```

Now the **staging content** is live on the **production URL** — zero downtime swap!

### Step 4 — Rollback (if needed)

Set back to `false` and apply:

```hcl
swap_slot_to_production = false
```

```bash
terraform apply
```

### Step 5 — Clean Up

```bash
terraform destroy
```

---

## 📸 Screenshots

> Screenshots will be added after completing the hands on demo

---

## 📚 References

<details open>
<summary><b>📖 HashiCorp Documentation</b></summary>

<br/>

| Resource | Link |
|:---|:---|
| Terraform AzureRM Provider | [Registry Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) |
| azurerm_service_plan | [Registry Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) |
| azurerm_linux_web_app | [Registry Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app) |
| azurerm_linux_web_app_slot | [Registry Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app_slot) |
| azurerm_app_service_source_control | [Registry Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_source_control) |
| azurerm_app_service_source_control_slot | [Registry Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_source_control_slot) |
| azurerm_web_app_active_slot | [Registry Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/web_app_active_slot) |
| Conditional Expressions | [HashiCorp Docs](https://developer.hashicorp.com/terraform/language/expressions/conditionals) |

</details>

<details open>
<summary><b>☁️ Microsoft Azure Documentation</b></summary>

<br/>

| Resource | Link |
|:---|:---|
| Azure App Service Overview | [Azure Docs](https://learn.microsoft.com/en-us/azure/app-service/overview) |
| Deployment Slots | [Azure Docs](https://learn.microsoft.com/en-us/azure/app-service/deploy-staging-slots) |
| Blue/Green Deployment | [Azure Docs](https://learn.microsoft.com/en-us/azure/architecture/web-apps/app-service/architectures/baseline-zone-redundant#deployment) |
| App Service Plans | [Azure Docs](https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans) |
| Continuous Deployment | [Azure Docs](https://learn.microsoft.com/en-us/azure/app-service/deploy-continuous-deployment) |

</details>

---

<div align="center">

<img src="https://img.shields.io/badge/Made%20with-%E2%9D%A4%EF%B8%8F-red?style=for-the-badge" alt="Made with Love"/>
<img src="https://img.shields.io/badge/Powered%20by-Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Powered by Terraform"/>
<img src="https://img.shields.io/badge/Deployed%20on-Azure-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white" alt="Deployed on Azure"/>

<br/><br/>

**⭐ Star this repo if you found it helpful!**

</div>
