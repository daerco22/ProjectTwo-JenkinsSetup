pipeline {
  agent any
  tools {
    "org.jenkinsci.plugins.terraform.TerraformInstallation" "terraform-1.3.1"
  }
  parameters {
    string(name: 'WORKSPACE', defaultValue: 'development', description:'setting up workspace for terraform')
	string(name: 'IP ADDRESS', description:'Local Machine IP Address')
	string(name: 'USERDATA TPL', description:'User Data Template')
	string(name: 'HOST OS', description:'Host Operating System')
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
        sh 'terraform --version'
		sh "echo \$PWD"
		sh "whoami"
      }
    }
  }

}