pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "ap-south-1"
    }

    stages {
        stage("Create an EKS Cluster") {
            steps {
                script {
                    dir('2-terraform-eks-deployment') {
                        sh "terraform init -upgrade"
                        sh "terraform apply -auto-approve -var-file=terraform.tfvars"
                    }
                }
            }
        }

        stage("Deploy to EKS") {
            steps {
                script {
                    dir('kubernetes') {
                        sh "aws eks update-kubeconfig --region ap-south-1 --name my-eks-cluster"
                        sh "kubectl apply -f nginx-deployment.yaml"
                        sh "kubectl apply -f nginx-server.yaml"
                    }
                }
            }
        }
    }
}