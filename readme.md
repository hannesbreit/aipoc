# Requirements which need to be done manually before spinning off the automation
## VNET Configuration
  - Vnet Address Space should be /24
  - Subnets should be as followed 

| subnet name | CIDR range | Delegation | UDR |
| -------- | -------- | -------- | -------- |
| ai-subnet | /27  | -  | adapted as needed, talk to network team |
| services-subnet  | /27 | - | same as above |
| database-subnet  | /27 | - | same as above |
| frontend-outbound-subnet  | /28 | Microsoft.Web/serverFarms | same as above |
| frontend-inbound-subnet  | /28 | - | same as above |
| backend-inbound-subnet  | /28 | - | same as above |
| backend-outbound-subnet  | /28 | Microsoft.Web/serverFarms | same as above |
| jumphost-subnet  | /28 | - | same as above |

## Service Connection

- create a Service Connection in Azure Devops in the respective Project with activated OpenID Connect feature. The person who creates the Service Connection must be either Application Administrator or Global Admin in Azure AD/ Entra ID and Administrator of the project at the same time.

- Once the Service Connection is created in Azure Entra ID a app registration will be created. This App registration must have following API permissions. To set these permission a Global Admin is needed:
  - API/Permission name: Group.Read.All
  - Type: Application
  - Admin consent required: Yes
  
- As soon as the permissions has been set admin consent need to be granted.

- The created Service Principal, must have access to the Frontend and Backend Repo in Azure DevOps to be able to add the Git Repo Links to the Web App. "Basic" license is recommended.

- On Subscription Level assign "Fresenius - Contributor" to the service connection.

## DNS configuration

- DNS configuration for each private endpoint must be added manually by the cloud platform team, as DNS zones are located in a different subscription. Manual changes to DNS configuration in the portal will be ignored in the code.

## Policies
- The first run of the pipeline will fail, once the public AI resources will be created. Don't be afraid. At the cloud team request a policy excemption for the policy "SCP - Cognitive Services accounts should disable public network access" inside of the initiative "SCP-Security" for the ai-test resource group. Then rerun the pipeline.

## Terraform state file management
- In the subscription create a new resource group which contains only one single storage account. Create a container named "terraform". Note down RG name, Storage Account name and Container name. 
 
## Code 
In the root of the project adjust following things:

| Folder | File | Thing to change | Comment |
| ----------- | ---------- | ---------- | ---------- |
| root  | variables.tf       | variable prefix<br>variable stage<br>variable location          |  |
| root  | main.tf       | all prefixes of all modules calls.<br>repo_url<br>custom_subdomain of openai module          |  |
| root  | backend.tf       | backend settings        |  |
| modules/services  | rbac.tf       | adjust persons to be able to read secrets in the Key Vault <br>Also a group can be added or removed from the code    |  |