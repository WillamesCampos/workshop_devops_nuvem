# Guia de Introdução ao Terraform

## 📚 O que é Terraform?

**Terraform** é uma ferramenta de **Infraestrutura como Código (IaC - Infrastructure as Code)** desenvolvida pela HashiCorp.

> "Terraform is an infrastructure as code tool that lets you build, change, and version infrastructure safely and efficiently. This includes low-level components like compute instances, storage, and networking; and high-level components like DNS entries and SaaS features."
> 
> — HashiCorp

### Características principais:

- **Multi-cloud**: Funciona com AWS, Azure, GCP, e muitos outros provedores
- **Linguagem declarativa**: Você descreve **o que** quer, não **como** fazer
- **Linguagem HCL**: HashiCorp Configuration Language - simples e legível
- **Versionamento**: Sua infraestrutura vira código, pode ser versionada no Git
- **Idempotência**: Executar múltiplas vezes produz o mesmo resultado

---

## 🎯 Conceitos Fundamentais

### Provider
O **provider** é o plugin que permite ao Terraform interagir com um provedor de nuvem (AWS, Azure, etc.).

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "sa-east-1"
}
```

### Resource
Um **resource** é um componente de infraestrutura que você quer criar (ex: instância EC2, bucket S3, VPC).

```hcl
resource "aws_s3_bucket" "meu_bucket" {
  bucket = "meu-bucket-exemplo"
  
  tags = {
    Name = "Meu Bucket"
  }
}
```

### State (Estado)
O **state** (`terraform.tfstate`) é um arquivo JSON que mapeia os recursos do Terraform para os recursos reais na nuvem. É como o Terraform "lembra" o que foi criado.

**⚠️ Importante**: O state é crítico! Sem ele, o Terraform não sabe o que já existe.

---

## 📁 Estrutura de Arquivos e Convenções

### Organização de Arquivos

A convenção é separar os arquivos por função:

```
meu-projeto-terraform/
├── main.tf          # Recursos principais e configuração do provider
├── variables.tf     # Variáveis de entrada (inputs)
├── outputs.tf       # Valores de saída (outputs)
├── terraform.tfvars # Valores das variáveis (opcional, não versionar)
└── .gitignore      # Ignorar arquivos sensíveis
```

### Descrição dos Arquivos

#### `main.tf`
Define os recursos principais e a configuração do provider.

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "Minha VPC"
  }
}
```

#### `variables.tf`
Define as variáveis que podem ser passadas para o Terraform.

```hcl
variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "sa-east-1"
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment deve ser dev, staging ou prod."
  }
}
```

#### `outputs.tf`
Define valores que serão exibidos após o `terraform apply`.

```hcl
output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block da VPC"
  value       = aws_vpc.main.cidr_block
}
```

### Boas Práticas de Organização

- **Não separe stacks por recurso individual**: Agrupe recursos relacionados à aplicação
- **Separe por contexto/ambiente**: Diferentes pastas para dev, staging, prod
- **Use módulos**: Para reutilizar código entre projetos

**Exemplo de estrutura:**
```
infrastructure/
├── networking/          # Stack de rede (VPC, subnets, etc.)
├── compute/            # Stack de computação (EC2, ECS, etc.)
├── storage/            # Stack de armazenamento (S3, EBS, etc.)
└── shared/             # Recursos compartilhados
```

---

## 🛠️ Comandos Básicos do Terraform

### Inicialização
```bash
terraform init
```
- Baixa os providers necessários
- Configura o backend
- **Sempre execute primeiro!**

### Validação
```bash
terraform validate
```
- Verifica se a sintaxe está correta
- Não verifica se os recursos podem ser criados

### Formatação
```bash
terraform fmt
```
- Formata os arquivos `.tf` automaticamente
- Mantém o código consistente

### Planejamento
```bash
terraform plan
```
- Mostra o que será criado/modificado/destruído
- **Sempre revise antes de aplicar!**
- Não faz alterações, apenas simula

### Aplicação
```bash
terraform apply
```
- Cria/modifica os recursos na nuvem
- Pede confirmação (use `-auto-approve` para pular)
- Cria/atualiza o arquivo `terraform.tfstate`

### Visualização do Estado
```bash
terraform show
```
- Mostra o estado atual da infraestrutura

### Listar Recursos
```bash
terraform state list
```
- Lista todos os recursos no state

### Destruição
```bash
terraform destroy
```
- **CUIDADO!** Remove todos os recursos
- Use com precaução, especialmente em produção

---

## 📦 Terraform Registry

O **Terraform Registry** é o repositório oficial de providers e módulos.

🔗 **https://registry.terraform.io/**

### Como usar:

1. Acesse o registry
2. Navegue até **Browse Providers** > **AWS** > **Documentation**
3. Procure pelo recurso que precisa (ex: `aws_s3_bucket`)
4. Veja exemplos de código e parâmetros disponíveis

**Exemplo**: Para criar um bucket S3, procure por `aws_s3_bucket` no registry e veja a documentação completa.

---

## 🔐 State e Remote Backend

### O que é o State?

Quando você executa `terraform apply`, o Terraform cria um arquivo `terraform.tfstate` que contém:

- Mapeamento entre recursos no código e recursos reais na nuvem
- Metadados dos recursos
- Dependências entre recursos

**⚠️ Problema**: Se você versionar esse arquivo no Git:
- Conflitos quando múltiplas pessoas trabalham
- Risco de corrupção do arquivo
- Pode causar problemas na infraestrutura real

### Solução: Remote Backend

Use um **backend remoto** para armazenar o state de forma segura e compartilhada.

#### Backend S3 + DynamoDB (AWS)

A solução recomendada na AWS é usar:

- **S3**: Armazena o arquivo `terraform.tfstate` remotamente
- **DynamoDB**: Implementa **State Locking** (bloqueio de estado)

**Configuração:**

```hcl
terraform {
  backend "s3" {
    bucket         = "meu-bucket-terraform-state"
    key            = "path/to/terraform.tfstate"
    region         = "sa-east-1"
    dynamodb_table = "terraform-state-lock"  # Tabela DynamoDB para locking
    encrypt        = true                     # Criptografa o state
  }
}
```

**⚠️ Importante**: Configure o backend **antes** de executar `terraform apply` pela primeira vez. Migrar depois é possível, mas mais trabalhoso.

---

## 🔒 State Locking

### O que é State Locking?

**State Locking** é uma funcionalidade que impede que múltiplas operações do Terraform sejam executadas simultaneamente no mesmo estado.

### Por que é importante?

Sem locking, se duas pessoas executarem `terraform apply` ao mesmo tempo:
- Pode causar corrupção do state
- Recursos podem ser criados/duplicados incorretamente
- Pode danificar a infraestrutura

### Como funciona?

1. Quando você executa `terraform apply`, o Terraform cria um **lock** no DynamoDB
2. Se outro processo tentar executar uma operação no mesmo estado, receberá um erro:
   ```
   Error: Error acquiring the state lock
   ```
3. Após a conclusão da operação, o lock é **liberado automaticamente**
4. Isso previne conflitos e corrupção

### Tabela DynamoDB para Locking

A tabela DynamoDB precisa ter uma chave primária chamada `LockID` (tipo String).

**Exemplo de criação via Terraform:**

```hcl
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-state-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform State Lock Table"
  }
}
```

### Forçar desbloqueio (use com cuidado!)

Se um lock ficar preso (ex: processo foi interrompido):

```bash
terraform force-unlock <LOCK_ID>
```

**⚠️ Use apenas se tiver certeza de que não há outra operação em andamento!**

---

## 📝 Boas Práticas

### 1. Sempre use Remote Backend
- Nunca versionar `terraform.tfstate` no Git
- Use S3 + DynamoDB (ou equivalente em outros clouds)

### 2. Use Variáveis
- Não hardcode valores
- Use `variables.tf` e `terraform.tfvars`
- Adicione `.tfvars` ao `.gitignore` se contiver secrets

### 3. Use Outputs
- Exponha informações úteis via outputs
- Facilita integração com outros sistemas

### 4. Sempre faça `terraform plan` antes de `apply`
- Revise as mudanças
- Evite surpresas

### 5. Use Tags
- Organize recursos com tags consistentes
- Facilita gestão e custos

### 6. Versionamento de Providers
- Especifique versões dos providers
- Evita quebras inesperadas

### 7. Organize por Contexto
- Agrupe recursos relacionados
- Separe por ambiente (dev/staging/prod)

### 8. Use Módulos
- Reutilize código
- Mantenha consistência entre projetos

---

## 🔗 Recursos Úteis

### Documentação Oficial
- **Terraform Docs**: https://developer.hashicorp.com/terraform/docs
- **AWS Provider**: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- **Terraform Registry**: https://registry.terraform.io/

### Boas Práticas
- **Terraform Best Practices**: https://www.terraform-best-practices.com/

### Referências Específicas
- **State Locking**: https://developer.hashicorp.com/terraform/language/state/locking
- **Backend S3**: https://developer.hashicorp.com/terraform/language/backend/s3
- **Remote Backend**: https://developer.hashicorp.com/terraform/language/backend/remote
- **AWS CLI Config**: https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-files.html

---

## 🎓 Próximos Passos

Agora que você entende os conceitos básicos:

1. ✅ Instale o Terraform (veja `terraform.md`)
2. ✅ Configure o AWS CLI (veja `aws_cli.md`)
3. ✅ Crie seu primeiro projeto Terraform
4. ✅ Configure um Remote Backend (S3 + DynamoDB)
5. ✅ Crie recursos simples (S3 bucket, VPC, etc.)
6. ✅ Explore o Terraform Registry
7. ✅ Aprenda sobre Módulos
8. ✅ Pratique com projetos reais

**Bons estudos! 🚀**
