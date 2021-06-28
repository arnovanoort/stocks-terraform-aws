# Stocks terraform aws

This project configures the deployment of the 2 services to AWS. This results in:
- a vpc with its subnets and security groups
- a kubernetes cluster consisting of
    - 2 pods for each of the 2 services(reader and algorithms)
    - load balancers to expose the services to the outside
 - a postgres RDS database for each of the services with configuration details injected into the services
 
 To start a deployment
 - make sure you have terraform installed<br/>_sudo apt-get install terraform_
 - make sure aws credentials have been configured<br/>_aws configure_
 - checkout this project and plan/apply the terraform. <br/>
   Navigate to the root of this project<br/>
   _terraform plan --out plan.out<br/>_
   _terraform apply plan.out_ 
 