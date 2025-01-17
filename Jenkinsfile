pipeline {
    agent any

    environment {
        // Define environment variables
        DOTNET_VERSION = '7.0'  // .NET SDK version
        DOCKER_IMAGE_NAME = 'vsmetgud/dotnet'  // Desired Docker image name
        DOCKER_REGISTRY = 'docker.io' // Docker Hub (use your registry if not Docker Hub)
        DOCKER_CREDENTIALS = 'dockerhub-id' // Jenkins Docker Hub credentials ID
        WORKSPACE_PATH = '/var/lib/jenkins/workspace/dotdocker'  // Your workspace path
        DOCKER_USER = 'vsmetgud'
        DOCKER_PASSWORD = 'Omganesh@!23456'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                checkout scm
            }
        }

        stage('Restore Dependencies') {
            steps {
                script {
                    // Restore NuGet dependencies
                    sh "dotnet restore $WORKSPACE_PATH/hello-world.csproj"
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    // Build the .NET application in Release mode
                    sh "dotnet build --configuration Release $WORKSPACE_PATH/hello-world.csproj"
                }
            }
        }

        stage('Publish') {
            steps {
                script {
                    // Publish the .NET application to the './publish' directory
                    sh 'dotnet publish $WORKSPACE_PATH/hello-world.csproj --configuration Release --output $WORKSPACE_PATH/publish'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the Dockerfile in the workspace
                    sh "docker build -f $WORKSPACE_PATH/Dockerfile -t $DOCKER_IMAGE_NAME:latest $WORKSPACE_PATH"
                }
            }
        }

        stage('Push Docker Image to Registry') {
            steps {
                script {
                    // Log in to Docker and push the Docker image
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USER --password-stdin $DOCKER_REGISTRY"
                        sh "docker push $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:latest"
                    }
                }
            }
        }
    }

    post {
        success {
            // Notify upon successful build and push
            echo 'Build, Dockerization, and Push were successful!'
        }
        failure {
            // Notify upon failure
            echo 'Build or Dockerization failed. Please check the logs for errors.'
        }
        always {
            // Clean workspace after build
            cleanWs()
        }
    }
}
