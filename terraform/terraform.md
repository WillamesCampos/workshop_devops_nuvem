# Instalação do Terraform no Linux Mint 22.1

Este documento registra o passo a passo realizado para instalar e configurar o Terraform no Linux Mint 22.1 (baseado no Ubuntu 22.04 “Jammy”).  
O Terraform é uma ferramenta de IaC (Infraestrutura como Código) usada para provisionar recursos em provedores como AWS, Azure e GCP.

---

## 📘 1. Atualizar o Sistema

```bash
sudo apt update && sudo apt upgrade -y
```

📦 2. Instalar Dependências Necessárias

```bash
sudo apt install -y gnupg software-properties-common curl
```

🔑 3. Adicionar a Chave GPG da HashiCorp

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

Verificar a chave:

```bash
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
```

🏗️ 4. Adicionar o Repositório da HashiCorp ao APT

Linux Mint 22.1 utiliza base Ubuntu Jammy (22.04):

```bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com jammy main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

📥 5. Instalar o Terraform

Atualizar os repositórios e instalar:

```bash
sudo apt update
sudo apt install terraform -y
```

🧪 6. Verificar a Instalação

```bash
terraform -v
```

Saída esperada:

```
Terraform v1.xx.x
```

⚙️ 7. (Opcional) Habilitar Autocomplete

```bash
terraform -install-autocomplete
```

Funciona tanto para bash quanto zsh.

🎉 Conclusão
Com esses passos, o Terraform foi instalado com sucesso no Linux Mint 22.1, utilizando o repositório oficial da HashiCorp.
Agora o ambiente está pronto para criar projetos de infraestrutura como código.
