#!/usr/bin/env groovy

pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "ap-south-1"
    }

    stages {

        stage("Create an EKS Cluster") {
            steps {
                dir('tf-eks') {
                    sh "terraform init -upgrade"
                    sh "terraform apply -auto-approve -var-file=terraform.tfvars"
                }
            }
        }

        stage("Deploy to EKS") {
            steps {
                dir('kubernetes') {
                    sh "aws eks update-kubeconfig --name my-eks-cluster --region ap-south-1"
                    sh "kubectl apply -f nginx-deployment.yaml"
                    sh "kubectl apply -f nginx-service.yaml"
                }
            }
        }
    }
}
