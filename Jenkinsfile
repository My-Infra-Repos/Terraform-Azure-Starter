#!/usr/bin/env groovy

pipeline {
  agent none
  environment {
    AZURE_CREDENTIALS_ID = //fill in
    DEPLOY_BRANCH = 'master'
    AZURECLI_VERSION = '2.11.1'
    TERRAFORM_VERSION = '0.12'
  }
  options {
    disableConcurrentBuilds()
  }
  stages {
    stage ('Prepare Terraform Environment') {
      agent {
        label 'docker-terraform-agent'
      }
      environment {
        //Set all these values for each environment
        VARIABLES_FILE = 'terraform.tfvars'
        TF_BACKEND_RG = 'terraform-rg'
        TF_BACKEND_ACCOUNT = //fill in name
        TF_BACKEND_LOCATION = 'centralus'
        TF_BACKEND_CONTAINER = 'tfstate'
        TF_BACKEND_KEY = 'terraform.tfstate'
      }
      stages {
        stage('Terraform Init') {
          steps {
            glAzureLogin(env.AZURE_CREDENTIALS_ID) {
              glTerraformInit(
                azureInit: true,
              )
            }
          }
        }
        stage('Terraform Plan') {
          steps {
            ansiColor('xterm') {
              glAzureLogin(env.AZURE_CREDENTIALS_ID) {
                glTerraformPlan(
                  additionalFlags: [
                    ('var-file'): env.VARIABLES_FILE,
                    out: 'plan.tfplan'
                  ]
                )
              }
              stash name: 'tfenv', includes: ".terraform/**/*, plan.tfplan"
            }
          }
        }
      }
    }
    stage('Validate Terraform Plan') {
      agent none
      when {
        branch env.DEPLOY_BRANCH
      }
      steps {
        timeout(time: 30, unit: 'MINUTES') {
          input(message: 'Apply this terraform plan?')
        }
      }
    }
    stage('Apply Terraform Plan') {
      agent {
        label 'docker-terraform-agent'
      }
      when {
        branch env.DEPLOY_BRANCH
      }
      steps {
        glAzureLogin(env.AZURE_CREDENTIALS_ID) {
          ansiColor('xterm') {
            unstash name: 'tfenv'
            glTerraformApply(
              planFile: 'plan.tfplan'
            )
          }
        }
      }
    }
  }
}
