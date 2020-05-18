// Scripted Pipeline
// Requires libraries from https://github.com/Prouser123/jenkins-tools
// Made by @Prouser123 for https://ci.jcx.ovh.

// Set ENV variable for ZeroTier version.
env.ZEROTIER_VERSION = '1.4.6'

node('docker-cli') {
  cleanWs()

  docker.image('jcxldn/jenkins-containers:base').inside {

    stage('Setup') {
	  scmVars = checkout scm
	  
	  sh "apk add make gcc build-base linux-headers curl && curl -L https://github.com/zerotier/ZeroTierOne/archive/${env.ZEROTIER_VERSION}.tar.gz | tar -zxvf -"
	}
	
	stage('Build') {
		sh "cd ZeroTierOne-${env.ZEROTIER_VERSION}/ && sed -i -e 's/-march=armv5//g' make-linux.mk && make SHARED=0 CC='gcc -static' CXX='g++ -static -march=armv6' && tar czvf zerotier-one-armv6.tar.gz zerotier-one"
		
		archiveArtifacts artifacts: 'ZeroTierOne-${env.ZEROTIER_VERSION}/zerotier-one-armv6.tar.gz', fingerprint: true
	}
  }
}