# Infraestrutura como código

Este projeto descreve as principais etapas para implantação de um cluster simples AWS Fargate 
usando como exemplo uma aplicação escrita em GO que calcula a sequência de fibonacci

## Antes de começar

Você deverá criar a sua configuração da AWS copiando o arquivo aws.tf.dist para aws.tf e inserindo suas chaves de API da AWS

## Etapas
O projeto está implantado em três etapas separadas em branchies (etapa-01, etapa-02, etapa-03) conforme descrito:

### Etapa 01 (branch etapa-01)

Na primeira etapa serão criados os seguintes elementos

1. VPC e as subredes
1. Nat e internet gateway
1. Registry ECR

#### Aplicação da receita
Acesse a pasta tf e execute o seguinte comando:
```
terraform apply
```
#### Compilação da imagem

Acesse a pasta da aplicação *go-app* execute o build:

```
docker build -t fib .
```

Após a compilação da imagem faça login no registry e faça o push da imagem

```
eval $(aws ecr get-login --no-include-email --region us-east-1)
```

```
docker tag fib:latest {id_do_registry}.dkr.ecr.us-east-1.amazonaws.com/fib:latest
docker push {id_do_registry}.dkr.ecr.us-east-1.amazonaws.com/fib:latest
```

### Etapa 02

Na segunda etapa serão criados os seguintes elementos:

1. Grupos de segurança
1. Roles
3. Cluster/Serviço/Task

### Etapa 03

Na terceira etapa serão criados os seguintes elementos:

1. Auto scaling
1. Projeto de teste jmeter