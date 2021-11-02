# Terraform 실습 - bastion 만들기
### 사전조건
* Terraform 설치 및 PATH 잡기
* 환경변수에 AWS_ACCESS_KEY , AWS_SECRET_KEY 셋팅하기
* pem 파일 만들고 local pc 에 ~/.ssh/ 밑에 배치하기

## epel
* epel repository 를 설치한다.

## preconfig
* 필요한 패키지들을 yum 으로 install 한다.
* ~/.vimrc 를 생성한다. 

## oh-my-zsh install
* oh-my-zsh 를 설치하기 위한 ansible module 을 설치한다. ~/.ansible/role 밑에 설치된다.
```
$ ansible-galaxy install gantsign.oh-my-zsh  
```

