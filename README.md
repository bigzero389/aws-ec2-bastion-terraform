# Terraform 실습 - bastion 만들기
## 개요
### 목적
* aws ec2 를 정해진 vpc 내에 bastion host 로 만든다
* bastion 은 공인IP 를 가지지만 22번 포트만 특정 IP 에서 접속 가능하다
* bastion 에 개발 및 운영에 필요한 여러가지 기본 도구들을 일괄로 설치한다.

## local pc 사전조건
### Terraform 설정
* Terraform 설치 및 PATH 잡기
* 환경변수에 AWS_ACCESS_KEY , AWS_SECRET_KEY 셋팅하기
* pem 파일 만들고 local pc 에 ~/.ssh/ 밑에 배치하기
* Windows 에서 Terraform 설치 및 환경변수 설정 [terraform setting] (https://infraboy.tistory.com/49)


### Ansible 설정
* ansible 이 설치되어 있어야 한다.
* ansible.cfg 를 구성한다.
* inventory_aws_ec2.yml 을 이용하여 정해진 Tag Name 의 ec2 를 가져온다.
* Windows 에서 AWS_SECRET_KEY/AWS_ACCESS_KEY 환경변수 설정 [aws key setting] (https://m.blog.naver.com/PostView.naver?isHttpsRedirect=true&blogId=shwotjd14&logNo=221226368685)
```
export AWS_ACCESS_KEY_ID='AAAAAAAAAAAAAAAAAAAAAAaaa'
export AWS_SECRET_ACCESS_KEY='BBBBBBBBBBBBBBBBBbbbb'
```

## 실행방법
### Terraform 으로 ec2 생성
* $PWD/terraform init
* $PWD/terraform valiate # 문법확인
* $PWD/terraform plan
* $PWD/terraform apply
* $PWD/terraform destory # 만들어진 bastion 을 삭제하는 경우
* $PWD/terraform show : grep public_ip # 만들어진 bastion 의 공인IP 를 확인한다. 
* cf : 공인IP 는 eip 가 아니므로 ec2를 종료하면 변경된다. 

### Ansible 로 ec2 내부 환경설정
* ansible-playbook ./bastion.yml

## Ansible role 구성.
### epel
* epel repository 를 설치한다.

### preconfig
* 필요한 패키지들을 yum 으로 install 한다.

### vim-setting
* ~/.vimrc 를 생성한다. 

### oh-my-zsh
* oh-my-zsh 을 bastion 에 설치하고 shell 을 zsh 로 변경한다.

### zsh-setting
* ~/.zshrc 에 alias 설정 및 theme 등을 설정한다.

### pem-copy
* local pc 의 pem 파일을 bastion 으로 upload 한다.



