pipeline {
  agent any
  tools {
    "org.jenkinsci.plugins.terraform.TerraformInstallation"
    "terraform-1.3.1"
  }
  parameters {
    choice(name: 'ACTION', choices: ['', 'apply', 'destroy'], description: 'Actions: will run terraform apply or terraform destroy')
    string(name: 'WORKSPACE', defaultValue: 'development', description: 'Setting up workspace for terraform')
    string(name: 'IP_ADDRESS', defaultValue: '180.191.190.235', description: 'Local Machine IP Address')
    string(name: 'USERDATA_TPL', defaultValue: 'docker_userdata.tpl', description: 'User Data Template')
    string(name: 'HOST_OS', defaultValue: 'linux', description: 'Host Operating System')
  }
  environment {
    TF_HOME = tool('terraform-1.3.1')
    TP_LOG = "WARN"
    PATH = "$TF_HOME:$PATH"
    ACCESS_KEY = credentials('AWS_ACCESS_KEY_ID')
    SECRET_KEY = credentials('AWS_SECRET_ACCESS_KEY')
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Terraform Init') {
      steps {
        sh "terraform init -input=false -no-color"
        sh "echo \$PWD"
        sh "whoami"
      }
    }
    stage('Terraform Format') {
      steps {
        sh "terraform fmt -list=true -write=false -diff=true -check=true"
      }
    }
    stage('Terraform Validate') {
      steps {
        sh "terraform validate -no-color"
      }
    }
    stage('Terraform Plan') {
      steps {
        script {
          try {
            sh "terraform workspace new ${params.WORKSPACE} -no-color"
          } catch (err) {
            sh "terraform workspace select ${params.WORKSPACE} -no-color"
          }
          sh "terraform plan -no-color -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' -var 'local_ip=${params.IP_ADDRESS}' -var 'user_data=${params.USERDATA_TPL}' -var 'host_os=${params.HOST_OS}' \
			-out terraform.tfplan;echo \$? > status"
          stash name: "terraform-plan", includes: "terraform.tfplan"
        }
      }
    }
    stage('Terraform Apply or Destroy') {
      steps {
        script {
          if (params.ACTION == "destroy") {
            def destroy = false
            try {
              input message: 'Can you please confirm the destroy', ok: 'Ready to Destroy the Config'
              destroy = true
            } catch (err) {
              destroy = false
              currentBuild.result = 'UNSTABLE'
            }
            if (destroy) {
              unstash "terraform-plan"
              sh 'terraform destroy terraform.tfplan -no-color'
            }
          } else {
            def apply = false
            try {
              input message: 'Can you please confirm the apply', ok: 'Ready to Apply the Config'
              apply = true
            } catch (err) {
              apply = false
              currentBuild.result = 'UNSTABLE'
            }
            if (apply) {
              unstash "terraform-plan"
              sh 'terraform apply terraform.tfplan -no-color'
            }
          }
        }
      }
    }
  }
}