# Kubernetes Cluster on EKS using eksctl:

## Prerequisites

1. AWS CLI Installation with Configured Credentials

- CLI installation  

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

- aws configuration

```bash
$ aws configure
  AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
  AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
  Default region name [None]: us-east-1
  Default output format [None]: json
```

2. kubectl installation

- `kubectl` installation
  
```bash
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.20.4/2021-04-12/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && mv ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bash_profile
kubectl version --short --client
```
# "eksctl" - The official CLI for Amazon EKS

- Creating K8s Cluster on EKS shown on Readme file but it is more complex, wee can achieve this by using 'eksctl' 
(brew tap: adds third-party repositories to homebrew)

```bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```
- Create Cluster
```bash
$ eksctl create cluster \
> --name test-cluster \
> --version 1.21 \
> --region us-east-1 \
> --nodegroup-name linux-nodes \
> --node-type t2.micro \
> --nodes 2
```
- Execution
kubectl get nodes
eksctl delete cluster --name "test-cluster'