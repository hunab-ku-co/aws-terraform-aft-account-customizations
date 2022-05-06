# AWS Foundation (Network) Connectivity  

This terraform code base works differently than regular terraform code  
It is based on the TietoEvry SAP for Azure Core V2 foundation  

## Terraform parametrization
The parametrisation of all the code comes from JSON files which start with predetermined prefixes  
In our case "aws-", these files are then processed into a large all encompassing variable by data-config.tf  

From there we start building each of the networking resources, there are some obvious dependencies like subnet  
depends on vpc so we code them (and its easier to follow the logic) in this order:

- vpc  
- vpc route table (not implemented, perhaps not required)
- subnet (*must have subnets in different AZs to connect them to a TGW attachment*)  
- subnet route table  
- subnet route table route  

Then there start to be more complex dependencies:  

- transit gateway  
- transit gateway attachment  
- transit gateway route table  
- transit gateway route table route  

## Local variables
For most of the above resources we create complex local variables which in some cases are two or three levels deep  
We then iterate over these local variables to create the resources. Each resource normally has its own *.tf file

