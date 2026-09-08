terraform {
  backend "s3" {
    bucket = "smari-devops-project-1"
    region = "ap-south-1"
    key    = "jenkins-server/terraform.tfstate"
  }
}
