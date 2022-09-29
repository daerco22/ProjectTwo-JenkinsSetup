pipeline {
  agent any
  tools {
    "org.jenkinsci.plugins.terraform.TerraformInstallation" "terraform-1.3.1"
  }
  parameters {
    string(name: 'WORKSPACE', defaultValue: 'development', description:'setting up workspace for terraform')
	string(name: 'IP_ADDRESS', description:'Local Machine IP Address')
	string(name: 'USERDATA_TPL', description:'User Data Template')
	string(name: 'HOST_OS', defaultValue: 'linux', description:'Host Operating System')
  }
  environment {
    TF_HOME = tool('terraform-1.3.1')
    TP_LOG = "WARN"
    PATH = "$TF_HOME:$PATH"
    ACCESS_KEY = credentials('AWS_ACCESS_KEY_ID')
    SECRET_KEY = credentials('AWS_SECRET_ACCESS_KEY')
  }
  stages{
    stage('checkout') {
      steps {
        checkout scm
      }
    }
    stage('TerraformInit') {
      steps {
        sh 'terraform init -input=false'
		sh "echo \$PWD"
		sh "whoami"
      }
    }
	stage('TerraformFormat'){
	  steps {
		sh "terraform fmt -list=true -write=false -diff=true -check=true"
	  }
	}
	stage('TerraformValidate'){
	  steps {
		sh "terraform validate -no-color"
	  }
    }
	stage('TerraformPlan'){
	  steps {
		script {
			try {
				sh "terraform workspace new ${params.WORKSPACE}"
			} catch (err) {
				sh "terraform workspace select ${params.WORKSPACE}"
			}
			sh "terraform plan -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' -var 'local_ip=${params.IP_ADDRESS}' -var 'user_data=${params.USERDATA_TPL}' -var 'host_os=${params.HOST_OS}' \
			-out terraform.tfplan;echo \$? > status"
			stash name: "terraform-plan", includes: "terraform.tfplan"
		}
	  }
	}
}