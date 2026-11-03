# TrackFlow

App web gratuito de controle de gastos pessoais. O usuário registra receitas e despesas, escolhe a categoria de cada
transação a partir de categorias padrão, e um painel mensal mostra para onde o dinheiro foi. A categorização automática
chega junto com a importação de extratos (fase futura).

> **Status:** em planejamento. A especificação completa (versão 1.0) está em [
`docs/trackflow-plano-v1.0.md`](docs/trackflow-plano-v1.0.md).

## Problema

Planilhas e cadernos exigem tempo e conhecimento; apps com automação costumam ser pagos ou burocráticos (Open Finance),
e várias contas em bancos diferentes dificultam uma visão única. Muita gente acaba nunca controlando os gastos.

**Público-alvo:** pessoas de 20 a 30 anos que nunca controlaram seus gastos por falta de tempo e não querem pagar por
automação (hipótese, ainda não validada).

## Escopo do MVP

- Cadastro, login e sessão com OAuth2 (JWT)
- Registro manual de receitas e despesas, com aviso de possível duplicata
- Categorização **manual** a partir de categorias padrão, com opção de aplicar a mesma categoria ao grupo de transações
  sem categoria de mesma descrição (ação pontual, não cria regra)
- Lista de transações sem categoria agrupadas por descrição
- Marcação de transações como "não conta"
- Painel mensal com ranking por categoria e comparação com o mês anterior
- CRUD de categorias
- Exportar e excluir todos os dados do usuário

**Fora do MVP:** importação OFX/CSV, categorização automática, Open Finance, IA, metas e orçamentos, múltiplas contas,
app nativo. Veja a seção 11 da especificação.

> O MVP prova viabilidade técnica e dá sinais iniciais de utilidade. Não comprova demanda de mercado.

## Categorização

- **No MVP:** toda categoria é escolhida pelo usuário. O usuário **não cria regras**, nem no MVP nem nas fases
  seguintes.
- **Na fase OFX (futuro):** um classificador probabilístico (ex.: Naive Bayes) calcula a probabilidade de cada categoria
  padrão a partir da descrição normalizada. Acima de um limiar de confiança, a categoria é atribuída automaticamente;
  abaixo, a transação fica sem categoria com sugestões. Categoria escolhida pelo usuário nunca é sobrescrita pelo
  sistema. Detalhes na seção 11 da especificação.

## Tecnologias

| Camada     | Tecnologia                                        |
|------------|---------------------------------------------------|
| Back-end   | Java 21, Spring Boot 3, Spring Security (OAuth2)  |
| Banco      | PostgreSQL, Flyway                                |
| Front-end  | SvelteKit (Svelte 5, SPA), Tailwind CSS, Chart.js |
| Testes     | JUnit 5, Mockito, Testcontainers, Vitest          |
| CI         | GitHub Actions                                    |
| Hospedagem | Vercel (front), OCI (API), Neon (banco)           |

A escolha do stack de front-end foi sugerida por IA; as demais, pelo desenvolvedor.

## Arquitetura

```
Navegador (SvelteKit) ──HTTPS + JWT──> API Spring Boot ──> PostgreSQL
                                        ├─ Resource Server (valida JWT)
                                        ├─ Controllers
                                        └─ Services: Transação, Normalização,
                                                     Categoria, Relatório
```

Autenticação: OAuth2 com par de chaves RSA (a privada assina, a pública valida), access token de 15 min e refresh token
rotativo de 7 dias. Detalhes na seção 6.3 da especificação.

## Estrutura do repositório

```
trackflow/
├── backend/        # API Spring Boot
├── frontend/       # SvelteKit
├── docs/           # Especificação do projeto
└── README.md
```

## Como rodar

> A ser preenchido durante a tarefa T01. Pré-requisitos previstos: Java 21, Node 20+, Docker (PostgreSQL e
> Testcontainers).

```bash
# Back-end (exemplo previsto)
cd backend
./mvnw spring-boot:run

# Front-end (exemplo previsto)
cd frontend
npm install
npm run dev
```

### Variáveis de ambiente

| Variável                            | Descrição                           |
|-------------------------------------|-------------------------------------|
| `DB_URL`, `DB_USER`, `DB_PASSWORD`  | Conexão com o PostgreSQL            |
| `JWT_PRIVATE_KEY`, `JWT_PUBLIC_KEY` | Par de chaves RSA (nunca versionar) |
| `CORS_ALLOWED_ORIGIN`               | Domínio do front-end                |

## Testes

```bash
cd backend && ./mvnw test      # unitários e integração (PostgreSQL via Testcontainers)
cd frontend && npm test        # Vitest
```

## Roadmap

| Marco                      | Entrega                                                                       |
|----------------------------|-------------------------------------------------------------------------------|
| M0 Fundação                | Repositório, banco, migrations e autenticação                                 |
| M1 Lançamento manual       | Transações e categorias                                                       |
| M2 Categorizar manualmente | Normalização, categorização manual, aplicar ao grupo e lista de sem categoria |
| M3 Analisar                | Totais e painel                                                               |
| M4 Preparar release        | Testes, bloqueios de release e deploy                                         |
| M5 Validar                 | Teste exploratório e documentação                                             |

Depois do MVP: importação OFX com categorização automática probabilística e demais itens da seção 11 da especificação.

## Privacidade

Dados financeiros são tratados como dados pessoais. Enquanto os bloqueios de release (seção 2.5 da especificação) não
forem concluídos, o app deve ser usado apenas com **dados fictícios**. Nunca versione dados reais ou segredos.

## Limitações conhecidas

- Sem importação de extratos: todo lançamento é manual.
- Sem categorização automática no MVP: toda categoria é escolhida pelo usuário.
- Estorno é tratado como receita comum (fluxo bruto, não gasto líquido).
- Partida a frio da API em plano gratuito pode causar demora na primeira requisição.
- UI/UX ainda a definir.

## Licença

A definir.