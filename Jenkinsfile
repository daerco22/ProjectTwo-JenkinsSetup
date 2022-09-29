pipeline {
  agent any
  tools {
    "org.jenkinsci.plugins.terraform.TerraformInstallation" "terraform"
  }
  parameters {
    string(name: 'WORKSPACE', defaultValue: 'development', description:'setting up workspace for terraform')
	string(name: 'IP ADDRESS', description:'Local Machine IP Address')
	string(name: 'USERDATA TPL', description:'User Data Template')
  }
  environment {
    TF_HOME = tool('terraform')
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
    stage('terraform') {
      steps {
        sh './terraformw apply -auto-approve -no-color'
      }
    }
  }

}