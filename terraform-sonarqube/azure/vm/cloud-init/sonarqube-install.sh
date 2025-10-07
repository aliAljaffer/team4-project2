#!/bin/bash
# Update & install dependencies
sudo apt update && sudo apt install -y unzip wget openjdk-17-jdk

# Create sonarqube user
sudo useradd -m -d /opt/sonarqube sonarqube

# Download and extract SonarQube
cd /opt
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.2.1.78527.zip
sudo unzip sonarqube-10.2.1.78527.zip
sudo mv sonarqube-10.2.1.78527/ sonarqube
sudo chown -R sonarqube:sonarqube /opt/sonarqube

sudo -u sonarqube bash -c "/opt/sonarqube/bin/linux-x86-64/sonar.sh start"
