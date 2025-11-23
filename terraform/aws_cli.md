# Instalação e Configuração do AWS CLI no Linux Mint

Este documento registra o passo a passo realizado para instalar e configurar o AWS CLI no Linux Mint 22.1, permitindo interagir com serviços da AWS pelo terminal.

---

## 📘 1. Download do Instalador

Baixe o pacote oficial do AWS CLI v2:

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
```

📦 2. Descompactar o Arquivo

```bash
unzip awscliv2.zip
```

⚙️ 3. Instalar o AWS CLI

```bash
sudo ./aws/install
```

Verificar a instalação:

```bash
/usr/local/bin/aws --version
```

Saída esperada:

```
aws-cli/2.xx Python/x.x.x Linux/x.x.x
```

🔑 4. Criar Access Keys no Console AWS
No Console AWS:

Acesse IAM → Users → Seu usuário

Vá em Security Credentials

Clique em Create Access Key

Copie a Access Key ID e a Secret Access Key

Recomenda-se usar um usuário com permissões adequadas (não o root).

🛠️ 5. Configurar o AWS CLI
Execute:

```bash
aws configure
```
Informe:

AWS Access Key ID

AWS Secret Access Key

Default region name (ex.: sa-east-1)

Default output format (json recomendado)

Isso cria:

`~/.aws/credentials`:
```ini
[default]
aws_access_key_id = AKIA...
aws_secret_access_key = ...
```

`~/.aws/config`:
```ini
[default]
region = sa-east-1
output = json
```

🧪 6. Testar a Configuração
Verificar identidade:

```bash
aws sts get-caller-identity
```

Listar usuários IAM:

```bash
aws iam list-users
```

Listar buckets S3:

```bash
aws s3 ls
```
Se os comandos retornarem dados, está funcionando corretamente.

🔐 7. Boas Práticas de Segurança
Nunca commitar ~/.aws/credentials no Git.

Proteja suas chaves de acesso.

Sempre que possível, habilite MFA.

Para produção, prefira IAM Roles ao invés de Access Keys.

🎉 Conclusão
Com esses passos, o AWS CLI foi instalado, configurado e testado com sucesso no Linux Mint. Agora seu ambiente está pronto para interagir com os serviços AWS diretamente pelo terminal.