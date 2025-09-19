.PHONY: init plan apply destroy validate format test clean

init:
	terraform init

plan:
	terraform plan -out=tfplan

apply:
	terraform apply tfplan

destroy:
	terraform destroy -auto-approve

validate:
	terraform validate

format:
	terraform fmt -recursive

test:
	cd src/lambda/inference && npm test

clean:
	rm -rf .terraform *.tfplan *.zip

deploy-dev:
	terraform workspace select dev || terraform workspace new dev
	terraform apply -var-file=environments/dev.tfvars -auto-approve

deploy-prod:
	terraform workspace select prod || terraform workspace new prod
	terraform apply -var-file=environments/prod.tfvars -auto-approve