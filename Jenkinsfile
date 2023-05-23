pipeline {
    agent any
    stages {
        stage('Code Checkout') {
            steps {
                git branch: 'main', 
                credentialsId: 'git-cred', 
                url: 'https://github.com/CloudHight/Jenkins-Pipeline-Project-01.git'
            }
        }
        stage('Code Analysis') {
            steps {
               withSonarQubeEnv('sonarqube') {
                  sh "mvn sonar:sonar"  
               }
            }   
        }
        stage("Quality Gate") {
            steps {
              timeout(time: 2, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
              }
            }
        }
        stage('Build Artifact') {
            steps {
                sh 'mvn -f pom.xml clean package'
            }
        }
        stage('Push Artifact to Nexus Repo') {
            steps {
                nexusArtifactUploader artifacts: [[artifactId: 'spring-petclinic',
                classifier: '',
                file: 'target/spring-petclinic-2.4.2.war',
                type: 'war']],
                credentialsId: 'nexus-repo',
                groupId: 'Petclinic',
                nexusUrl: '15.237.36.180:8081',
                nexusVersion: 'nexus3',
                protocol: 'http',
                repository: 'nexus-repo',
                version: '1.0'
            }
        }
        stage('Trigger Playbooks on Ansible') {
            steps {
                sshagent (['ansible-privatekey']) {
                      sh 'ssh -t -t ec2-user@13.38.110.13 -o strictHostKeyChecking=no "cd /etc/ansible && ansible-playbook /opt/docker/docker-image.yml"'
                      sh 'ssh -t -t ec2-user@13.38.110.13 -o strictHostKeyChecking=no "cd /etc/ansible && ansible-playbook /opt/docker/docker-container.yml"'
                      sh 'ssh -t -t ec2-user@13.38.110.13 -o strictHostKeyChecking=no "cd /etc/ansible && ansible-playbook /opt/docker/newrelic-container.yml"'
                  }
              }
        }
        stage('slack notification') {
            steps {
                slackSend channel: '1st-may-pet-adoption-containerisation-project-using-jenkins-pipeline-eu-team-2', 
                message: 'successful application deployment', 
                tokenCredentialId: 'slack'
            }
        }
    }                   
}