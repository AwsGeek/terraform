
# Cloudformation
These templates are here as reference for how to build the same VPC using the Cloudformation CLI instead of terraform. These tempaltes build a simple VPC with two availability zones, a public and private subnet in each AZ, and a NAT gateway in each public subnet. Edit the defaults in parameters.json as necessary to update region, CIDR blocks, etc. 

To build, cd to the cloudformation folder, then: 
```
aws s3 cp --recursive . s3://<your bucket and path>
```
to copy all of the template files to S3, followed by this:
```
aws --region <your region> cloudformation create-stack \
--stack-name <your stack name> \
--template-url https://s3.amazonaws.com/<your bucket and path>/main.json \
--parameters file://json/parameters.json \
--tags file://json/tags.json
```
You can monitor the progress of the build this way:
```
aws --region <your region> cloudformation describe-stacks --stack-name <your stack name>
```
To tear down:
```
aws --region <your region> cloudformation delete-stack --stack-name <your stack name>
```
