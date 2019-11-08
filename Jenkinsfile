pipeline {
  agent {
    label 'common'
  }
  environment {
    APP_NAME = 'hellogrpc3'
  }
  stages {
    stage('notify-start') {
      when {
        anyOf {
          branch 'master'; branch 'release/*'; tag "release*"
        }
      }
      steps {
        sh '''gitmessage=$(git log --format=%B -n 1)
python /home/makeblock/dingding.py -s "${APP_NAME} CI start on ${BRANCH_NAME}" -l "http://ci.makeblock.com/blue/organizations/jenkins/common-${APP_NAME}/activity" -r https://oapi.dingtalk.com/robot/send?access_token=32d59d5a92ad394c1d2e6359f2c7120bfa04fe2d0cdee067f9a4a58b6cb0eaeb -p "http://img3.imgtn.bdimg.com/it/u=2487463612,3263179857&fm=26&gp=0.jpg" -m "${gitmessage}"'''
      }
    }
    stage('SQ analysis') {
      when {
        anyOf {
          branch 'master'; branch 'release/*'
        }
      }
      options {
        skipDefaultCheckout()
      }
      environment {
        APP_VERSION = sh(script: 'node -p "require(\'./package.json\').version"',, returnStdout: true).trim()
      }
      steps {
        script {
          scannerHome = tool 'SonarQubeScanner'
        }

        withSonarQubeEnv('SonarQube Server') {
          sh 'make utest'
          sh '/home/makeblock/jenkins/tools/hudson.plugins.sonar.SonarRunnerInstallation/SonarQubeScanner/bin/sonar-scanner -Dsonar.projectKey=${APP_NAME}:key -Dsonar.projectName=${APP_NAME} -Dsonar.projectVersion=${APP_VERSION} -Dsonar.sources=. -Dsonar.exclusions=**/proto/** -Dsonar.language=go -Dsonar.tests=. -Dsonar.test.inclusions=**/*_test.go -Dsonar.test.exclusions=**/vendor/**,**/proto/** -Dsonar.go.coverage.reportPaths=coverage.data -Dsonar.coverage.dtdVerification=false'
        }
      }
    }
    stage('build-dev') {
      when {
        anyOf {
          branch 'master'
        }
      }
      options {
        skipDefaultCheckout()
      }
      steps {
        sh 'make build-master'
      }
    }
    stage('build-test|prod') {
      when {
        anyOf {
          branch 'release/*'
        }
      }
      options {
        skipDefaultCheckout()
      }
      steps {
        sh 'make build-release'
      }
    }
    stage('deploy-dev') {
      when { 
        anyOf { 
          branch 'master'
        }
      }
      options {
        skipDefaultCheckout()
      }
      steps {
        sh 'make deploy-dev'
      }
    }
    stage('deploy-test') {
      when { 
        anyOf { 
          branch 'release/*'
        }
      }
      options {
        skipDefaultCheckout()
      }
      steps {
        sh 'make deploy-test'
      }
    }
    stage('deploy-prod') {
      when { tag "release*" }
      options {
        skipDefaultCheckout()
      }
      steps {
        sh 'make deploy-prod-preview'
        sh '''gitmessage=$(git log --format=%B -n 1)
python /home/makeblock/dingding.py -s "${APP_NAME} ${BRANCH_NAME} 确认部署" -l "http://ci.makeblock.com/blue/organizations/jenkins/common-${APP_NAME}/activity" -r https://oapi.dingtalk.com/robot/send?access_token=32d59d5a92ad394c1d2e6359f2c7120bfa04fe2d0cdee067f9a4a58b6cb0eaeb -p "http://img3.imgtn.bdimg.com/it/u=2487463612,3263179857&fm=26&gp=0.jpg" -m "${gitmessage}"'''        
        input "确认要部署线上环境吗？"
        sh 'make deploy-prod'
      }
    }
    stage('notify') {
      when { 
        anyOf { 
          branch 'master'; branch 'release/*'; tag "release*"
        }
      }
      steps {
        sh '''gitmessage=$(git log --format=%B -n 1)
python /home/makeblock/dingding.py -s "${APP_NAME} CI Success on ${BRANCH_NAME}" -l "https://cs.console.aliyun.com/?spm=5176.12818093.recent.dcsk.488716d0HjDKAk#/k8s/deployment/list" -r https://oapi.dingtalk.com/robot/send?access_token=32d59d5a92ad394c1d2e6359f2c7120bfa04fe2d0cdee067f9a4a58b6cb0eaeb -p "http://img3.imgtn.bdimg.com/it/u=2487463612,3263179857&fm=26&gp=0.jpg" -m "${gitmessage}"'''
      }
    }
  }
  post {
    failure {
      sh 'python /home/makeblock/dingding.py -t fail -r https://oapi.dingtalk.com/robot/send?access_token=32d59d5a92ad394c1d2e6359f2c7120bfa04fe2d0cdee067f9a4a58b6cb0eaeb -m "$(node -p \"require(\'./package.json\').name\")"'
    }
  
  }
}