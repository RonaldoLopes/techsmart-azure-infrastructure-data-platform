# TechSmart Data Platform — Azure + Databricks

Plataforma de dados completa construída no Azure e Databricks para transformar dados de múltiplas fontes em insights de negócio.

## 🎯 O Projeto TechSmart

TechSmart é uma varejista de acessórios eletrônicos com dados espalhados em três sistemas:
- **ERP**: arquivos CSV com transações diárias
- **API de clima**: dados de temperatura por região
- **Sensores IoT**: leitura contínua de estoque via Event Hubs

**Objetivo**: consolidar esses dados em um lakehouse para responder perguntas como "qual foi a receita de ontem por região?" em segundos, não em uma semana.

## 🏗️ Arquitetura

```
Fontes de dados
      ↓
    [LANDING] — arquivo cru, como chegou
      ↓
    [BRONZE] — Delta Lake fiel à origem + metadados
      ↓
    [SILVER] — limpo, tipado, cruzado, quarentena
      ↓
    [GOLD] — star schema, KPIs prontos para negócio
      ↓
Consumo: Power BI | Databricks SQL | Azure OpenAI
```

## 🛠️ Stack Tecnológico

| Camada | Tecnologia |
| --- | --- |
| Orquestração | Azure Data Factory + Databricks Workflows |
| Armazenamento | Azure Storage (ADLS Gen2 com HNS) |
| Processamento | Apache Spark + Databricks |
| Catálogo | Unity Catalog (governança, permissões, linhagem) |
| Ingestão | Auto Loader, Event Hubs, Azure SQL |
| Transformação | PySpark, Delta Lake, SQL |
| ML/IA | MLflow, Azure OpenAI |
| Consumo | Power BI, Databricks SQL, Synapse |
| Segurança | RBAC, máscaras, filtros de linha, LGPD |
| CI/CD | GitHub Actions, Asset Bundles |

## 📁 Estrutura de Pasta

```
techsmart-azure-infrastructure/
├── main.tf                  # Infraestrutura base (RG, Storage)
├── .gitignore              # Arquivos ignorados
└── README.md               # Este arquivo
```

## 🚀 Como começar

### Pré-requisitos
- Terraform instalado
- Azure CLI instalado
- Conta Azure ativa
- GitHub conectado ao Azure

### 1. Clone e configure
```bash
git clone https://github.com/seu-usuario/techsmart-azure-infrastructure.git
cd techsmart-azure-infrastructure
az login
```

### 2. Deploy da infraestrutura
```bash
terraform init
terraform plan
terraform apply
```

### 3. Próximos passos
- Criar Databricks Workspace (Premium tier)
- Configurar Unity Catalog
- Provisionar Event Hubs
- Configurar Data Factory pipelines

## 📊 Camadas de Dados

### Landing
- Armazenamento temporário
- Arquivos como chegam das fontes
- Sem transformação, sem lógica

### Bronze
- Primeira transformação no Delta Lake
- Adiciona metadados: `_ingest_ts`, `_source_file`
- Cumpre contrato com origem

### Silver
- Limpeza: tipagem, deduplicação, tratamento de nulos
- Integração: joins entre fontes
- Quarentena: linhas reprovadas com motivo

### Gold
- Star schema pronto para analytics
- Fatos e dimensões
- Agregações pré-calculadas
- Pronto para Power BI, BI tools, API

## 🔒 Governança

- **Unity Catalog**: catálogo centralizado, permissões granulares
- **RBAC no Azure**: acesso a dados baseado em role
- **Máscaras**: PII (CPF, email) mascarado por padrão
- **Filtros de linha**: usuários veem só dados relevantes
- **LGPD**: pseudonimização com hash+sal, right-to-be-forgotten com DELETE+VACUUM

## 💰 Custos (estimativa mensal)

| Recurso | Custo |
| --- | --- |
| Storage Account (ADLS Gen2, 100 GB) | ~$2-3 |
| Databricks (Dev, 10 DBU/dia) | ~$50-80 |
| Data Factory (1 pipeline/dia) | ~$5-10 |
| Event Hubs (básico) | ~$10-15 |
| **Total** | **~$70-110** |

*Valores ilustrativos. Varia por uso real.*

## 📚 Documentação Completa

A apostila completa **"Plataforma de Dados Azure + Databricks"** contém:
- 23 módulos de conceito e prática
- 108 páginas com laboratórios
- Seção de erros comuns e soluções
- Glossário de termos
- Checklist de aprendizado

## 🎓 Roteiro de Aprendizado

1. **Fundação Azure** (Módulos 1-2)
   - Conceitos de lakehouse
   - Storage Account, Key Vault, Budget

2. **Databricks a Fundo** (Módulos 3-13)
   - Spark, Delta Lake, Unity Catalog
   - Clustering, Warehouses, Streaming
   - MLflow, Auto Loader

3. **Projeto End-to-End** (Módulos 14-23)
   - Data Factory ↔ Databricks
   - Camadas Bronze, Silver, Gold
   - Azure OpenAI, Power BI, Workflows
   - LGPD, Segurança, Custos

## 🤝 Contribuições

Sugestões e correções são bem-vindas. Abra uma issue ou PR.

## 📝 Licença

MIT

---

**Última atualização**: Agosto 2026  
**Status**: Em desenvolvimento  
**Próximos**: Key Vault, Databricks Workspace, GitHub Actions
