pipeline {
    agent any

    tools {
        jdk 'jdk21'
        maven 'maven3'
    }

    environment {
        SCANNER_HOME = tool('sonar-scanner')
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main',credentialsId: 'git-cred',url: 'https://github.com/Saumya-km/demo-app.git'
            }
        }
        stage('Read Maven Version') {
          steps {
            script {
               env.APP_VERSION = sh(
                   script: "mvn help:evaluate -Dexpression=project.version -q -DforceStdout",
                   returnStdout: true
                  ).trim()
             echo "Application Version: ${env.APP_VERSION}"
              }
          }
      }
        stage('Compile') {
            steps {
                sh 'mvn compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('file System Scan') {
            steps {
                sh 'trivy fs --format table -o trivy-fs-report.html .'
            }
        }
         stage('sonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                   sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=demo-app \
                   -Dsonar.projectKey=demo-app -Dsonar.java.binaries=. '''
               }
            }
         }
            stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token' 
                 }
             }
         }
          stage('PackageApp into jar & Publish artifact') {
            steps {
                withMaven(globalMavenSettingsConfig: 'global-setting', jdk: 'jdk21', maven: 'maven3',mavenSettingsConfig:"",traceability: true) {
                sh "mvn deploy"
              }
           }
        }
        stage('Build & Tag docker image') {
            steps {
                sh 'docker build --build-arg NEXUS_URL=http://52.87.235.209:8081 --build-arg APP_VERSION=$APP_VERSION -t skuma011/demo-app:$APP_VERSION .'
            }
          }
          stage('Docker Image scanning') {
            steps {
                sh 'trivy image --format table -o trivy-image-report.html skuma011/demo-app:$APP_VERSION '
                }
          }
          stage('Push Docker Images into DockerHub ') {
            steps {
                 withCredentials([usernamePassword(credentialsId: 'docker-red',usernameVariable: 'DOCKER_USERNAME',passwordVariable: 'DOCKER_PASSWORD')]) {                 
                    sh '''
                     echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                     docker push skuma011/demo-app:$APP_VERSION
                     '''
                   }
              }
         }
         stage('demo-app-deploy-in-k8s') {
            steps {
               withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'k8s-cred', namespace: 'demo-app-deployment', restrictKubeConfigAccess: false, serverUrl: 'https://172.31.35.168:6443') {
                   sh 'kubectl apply -f deployment.yml'
                 }
             }
         }
    }
}
