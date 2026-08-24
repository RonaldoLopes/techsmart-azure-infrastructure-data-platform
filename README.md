
## 🔐 Segurança básica

1. **Nunca commita `terraform.tfstate`** — contém senhas
```bash
   # Já está no .gitignore
   git check-ignore terraform.tfstate
```

2. **Azure Key Vault** — guardará segredos depois (Módulo 6)
```bash
   terraform output openai_key
   # Saída: [redacted]
```

3. **RBAC do Azure** — seu usuário é Owner por padrão
```bash
   az role assignment list --scope /subscriptions/SUB_ID
```

## 🆘 Troubleshooting

### `InvalidSubscriptionId: ... is malformed`
Você deixou um placeholder. Use:
```bash
az account show --query id -o tsv
```
E copie o valor real em `main.tf`.

### `Insufficient permissions`
Seu usuário precisa ser **Owner** ou **Contributor** na subscription. Confirme:
```bash
az role assignment list --query "[?principalName=='seu-email@exemplo.com']"
```

### `The subscription could not be found`
Listar todas:
```bash
az account list --query "[].{name:name, id:id}"
```
E trocar com:
```bash
az account set --subscription "ID_OU_NOME"
```

### Workspace criou, mas não consigo entrar
Pode levar 1-2 minutos para ficar pronto. Aguarde um pouco, depois:
```bash
terraform output workspace_url
```
E abra no navegador. Você será redirecionado para login.

## ✅ Validações

Confirmar que tudo funcionou:

```bash
# Listar recursos criados
az resource list -g rg-techsmart-dev --query "[].{name:name, type:type}"

# Confirmar que o workspace está pronto
az databricks workspace show -g rg-techsmart-dev -n dbw-techsmart-dev
```

## 🗑️ Destruir (quando não precisar mais)

```bash
terraform destroy
```

Digite `yes` e aguarde. Tudo será removido (exceto alguns backups de armazenamento que levam 7 dias).

⚠️ **Isso é irreversível. Confirme que você quer realmente.**

## 📚 Próximos passos

1. ✅ **Você está aqui** — infraestrutura do Azure criada
2. **Módulo 3** — conhecer o workspace Databricks
3. **Módulo 4-6** — compute, Spark, Delta Lake
4. **Módulo 7+** — carregar dados reais

Abra a apostila PDF (113 páginas, 23 módulos) para o passo a passo completo.

## 📖 Referência rápida (Terraform)

```bash
terraform init           # inicializa (rode uma vez)
terraform fmt            # formata bonito
terraform validate       # valida sintaxe
terraform plan           # mostra o que vai mudar
terraform apply          # faz de verdade
terraform apply -auto-approve   # faz sem perguntar
terraform destroy        # apaga tudo
terraform output         # vê as saídas
terraform state list     # lista recursos
terraform state show ENDERECO   # detalhe de um recurso
```

## 🤝 Contribuindo

Encontrou erro na apostila? Sugestão de melhoria?

1. Fork o repositório
2. Crie uma branch `feature/seu-nome`
3. Commit com mensagem clara
4. Pull Request

## 📝 Licença

Este projeto é code+docs de aprendizado. Livre para usar, modificar e compartilhar com atribuição.

---

**Versão:** 1.0  
**Última atualização:** Agosto 2026  
**Próxima etapa no README:** Data Factory (Módulo 16), Event Hubs (Módulo 17), OpenAI (Módulo 18)