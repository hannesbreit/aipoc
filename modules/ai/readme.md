# Requirements

- DNS configuration for private endpoint must be added manually by cloud platform team, as DNS zones are located in a different subscription. Manual changes to DNS configuration in the portal will be ignored in the code.

- in order to get private connectivity for Azure OpenAI resource and Azure AI Search a form must be filled out and requested at Microsoft. 
<br>https://forms.office.com/pages/responsepage.aspx?id=v4j5cvGGr0GRqy180BHbRw_T3EIZ1KNCuv_1duLJBgpUMUcwV1Y5QjI3UTVTMkhSVUo3R09NNVQxSyQlQCN0PWcu <br>
To get private connectivity also Role-based-access must be used to authenticate against Azure AI Search. <br><br>
in Terraform this code snippet must be definied
```tf 
local_authentication_enabled  = false
```
