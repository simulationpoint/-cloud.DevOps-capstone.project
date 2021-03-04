// Jesh Amera Mar 01/2021

pipeline {
	agent any
        // config docker hub
        environment {
		  DOCKER_HUB_REPO = "211896/gmn_docker_image"
		  CONTAINER_NAME = "gmn_docker_image"
		  REGISTRY_CREDENTIAL = "dockerhub"
        }
        // set pull trigger 
        triggers {
            pollSCM '* * * * *'
        }
    // slack global notifier
    stages {
        stage('slack notification') {
         steps {
            script {
                slackSend message: 
                         "Jenkins, started building the job - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL} | open console output >)"
                }
            }
         }
        // remove project folder 
		stage('clean workspace') {
			steps {
				script {   
					sh 'rm -rf cloud.devops-capstone.project'						
				}
			}
		}
        // clone repo to local machine	
		stage('clone git repo') {
			steps {
				script{
					sh 'git clone https://github.com/simulationpoint/cloud.devops-capstone.project.git' 
                    slackSend message: 
                            "clone repo successful - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL} | open console output >)"
				}		
			}
		}
        // build docker image, if then, push docker image to docker hub
        stage('build image') {
			steps {
				script {
                    dir('.') {
					sh '/usr/local/bin/docker image build -t $DOCKER_HUB_REPO:latest .'
					sh '/usr/local/bin/docker image tag $DOCKER_HUB_REPO:latest $DOCKER_HUB_REPO:$BUILD_NUMBER'  
                    }             
				}
			}
		}
        // push image to docker hub
        stage('push  dockr image') {
            steps {
                script {       
                    sh '/usr/local/bin/docker push 211896/gmn_docker_image'                                             
                }
            }
        }

        // alert/notify via slack, telegram, whatsapp, and email 
        stage('image push alert') {
			steps {
                script {
                slackSend message: 
                "Docker image got build, and pushed successfully - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL} | open console output >)"
                }
			}
		}
        stage('kubernetes dploy') {
            steps {
                dir('.') {
                    script {
                        sh 'kubectl apply -f kubernetes.yaml'
                        sh 'kubectl get service/kube-app-deployment'
                    }
                }
            }
        }
        stage('minikube service') {
            steps {
                dir('.') {
                    script {
                        sh 'minikube service kubernetes-app-service'
                        slackSend message: 
                            "kubernetes claster deployed successfully - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL} | open console output >)"
                    }
                }
            }
        }
    }
}

  //       // terraform init, if then, terraform apply		
		// stage('tf init -> tf apply') {
		// 	steps {
		// 		script {
  //                   dir('./cloud.devops-capstone.project') {
  //                   sh '/usr/local/bin/terraform init'
  // 				    sh '/usr/local/bin/terraform apply -auto-approve'
  //                   }
		// 		}
  // 			}
		// }
  //       // get all cluster information				
		// stage('get cluster info') {
		// 		steps {
		// 			script { 
		// 			   sh 'kubectl get all --all-namespaces'
		// 		  }
		// 	 }				
		// }
  //       // alert/notify via slack, telegram, whatsapp, and email 
  //       stage('terraform alert center') {
  //           steps {
  //               script {
		// 		slackSend message: 
  //                       "flask app deployed successfully using terraform - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL} | open console output >)"
  //               }
		// 	}
		// }
  //       // remove elk project folder
		// stage('clean ELK workspace') {
		// 	steps {
		// 		script {   
  //                   sh 'cd ~/Desktop'
		// 			sh 'rm -rf dockerized-elk-stack'
  //               }						
		// 	}
		// }
  //       // configure ELK stack
  //       stage('monitoring center') {
  //           steps {
  //               script {
  //               sh 'cd ~/Desktop'
  //               sh 'git clone https://github.com/simulationpoint/dockerized-elk-stack.git'
  //               sh 'cd dockerized-elk-stack/docker-elk' 
  //               sh 'docker-compose up'
  //               }
		// 	}
		// }
  //       // open new terminal continue - configure ELK stack  
  //       stage('configure metricbeat') {
  //           steps {
  //               script {
  //               slackSend message: 
  //                       " docker-compose up and running - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL} | open console output >)"
  //               sh 'cd ~/Desktop/dockerized-elk-stack/docker-elk'
  //               sh 'curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.11.0-darwin-x86_64.tar.gz'
  //               sh 'tar xzvf metricbeat-7.11.0-darwin-x86_64.tar.gz'
  //               sh 'mv metricbeat-7.11.0-darwin-x86_64 metricbeat' 
  //               sh 'cd metricbeat' 
  //               sh 'mv ~/Desktop/elk/metricbeat.yml metricbeat/'
  //               sh 'mv ~/Desktop/elk/docker.yml ~/metricbeat/modules.d/'
  //               sh './metricbeat modules enable docker'
  //               sh './metricbeat setup'
  //               sh './metricbeat -e'
  //               sh 'kubectl expose deployment kubernetes_deployment  --type=LoadBalancer --port=9090'
  //               }
		// 	}
		// }
  //   }
//}