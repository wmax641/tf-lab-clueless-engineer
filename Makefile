
IDENTITY=$(shell aws sts get-caller-identity | jq -r '.Arn' | cut -d':' -f5-)
ACCOUNT=$(shell echo "$(IDENTITY)" | cut -d":" -f1)
BASE_NAME=$(shell basename $(CURDIR))
REGION="ap-southeast-2"

init:
	terraform init \
		-backend-config="bucket=tf-${ACCOUNT}" \
		-backend-config="key=${BASE_NAME}" \
		-backend-config="region=${REGION}" 

fmt:
	terraform fmt -write=false -diff=true -check=true

validate:
	terraform validate

plan:
	terraform plan -input=false -out=tfplan-${ACCOUNT}

apply:
	terraform apply -input=false tfplan-${ACCOUNT}

destroy:
	terraform plan -destroy -input=false -out=tfplan-${ACCOUNT}
	terraform apply -input=false tfplan-${ACCOUNT}
