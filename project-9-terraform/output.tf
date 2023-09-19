output jenkins_server_ip {
  value = aws_instance.Jenkins.public_ip
}
output ansible_manager_ip {
  value = aws_instance.ansible_manager.public_ip
}
output ansible_docker_ip {
  value = aws_instance.ansible_minikube.public_ip
}