pipeline {
    agent any 
    environment{
        ArtifactId = readMavenPom().getArtifactId()
        Version = readMavenPom().getVersion()
        GroupId = readMavenPom().getGroupId()
        Name = readMavenPom().getName()
    }
    
    stages{
        stage("git checkout"){
            steps{
                git branch: 'master', url: 'https://github.com/vscbobba/Project-9.git'
            }
        }
        stage("build"){
            steps{
                sh 'mvn clean package'
            }
        }
        stage("static code analayis"){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonar') {
                    sh 'mvn sonar:sonar'
                    }
                }
            }
        }    
        stage("upload artifact"){
            steps{
                script{
                    def NexusRepo = "Project-9"
                    nexusArtifactUploader artifacts: [[artifactId: "${ArtifactId}", classifier: '',
                    file: "target/${ArtifactId}-${Version}.war", type: 'war']], 
                    credentialsId: 'nexus', groupId: "${GroupId}", nexusUrl: 'localhost:8081', nexusVersion: 'nexus3', 
                    protocol: 'http', repository: "${NexusRepo}", version: "${Version}"
                }
            }
        }
        stage("deploy artifact on to kubernetes"){
            steps{
                script{
                    sshPublisher(publishers: 
                    [sshPublisherDesc(configName: 'ansible', 
                    transfers: 
                    [sshTransfer(cleanRemote: false, excludes: '', 
                    execCommand: 'ansible-playbook /tmp/Ansible/deploy-to-kubernetes.yml -i /home/ansadmin/hosts',
                    execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, 
                    patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', 
                    sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
                }
            }
        }
    }
}