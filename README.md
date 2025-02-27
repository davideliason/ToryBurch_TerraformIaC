# TonyBurch Terraform IaC Code
## Feb 2025
### David Eliason

**Description**
This is the working code for building the infrastructure to power the Tony Burch web application. The Tony Burch project is a collaborative effort between At, Pilar, and myself, David Eliason. This is a parallel repo for reference and to allow mrore-robust commenting.

The code structure attempts to modularize code as much as possible, using variables to move away from hard-coding and modules for the parent resource groups.

**Technical**
- VPC created, with 10.16.0.0/16 to allow wide CIDR scope, within us-west-2
- Two Availability Zones used, us-west-2a, us-west-2b
- Each AZ has a public and private subnet, for failover and redundancy
- Internet Gateway (IGW) attached to the VPC for internet access of resources
- Public route table created and associated with public subnets
