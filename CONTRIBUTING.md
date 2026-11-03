# Convenções do projeto TrackFlow

Este documento define o fluxo de trabalho com Git e GitHub (tarefa T01). Vale para todo o desenvolvimento do projeto.

> Regras de ouro: **uma issue = uma branch = um PR**; tudo nasce da `develop`; **nada é commitado direto** em `main`
> ou `develop`; nenhum segredo ou dado real entra no repositório.

---

## 1. Fluxo Git

### Branches permanentes

| Branch    | Função                                                    | Quem recebe merge                    |
|-----------|-----------------------------------------------------------|--------------------------------------|
| `main`    | Código estável, pronto para entrega (MVP e releases)      | Somente `develop`, via PR            |
| `develop` | Integração: junta o trabalho concluído de todas as issues | Branches de issue, via PR com squash |

### Ciclo de uma issue

```
main ──────────────────────────────────────────────●──── (release / MVP)
                                                    ↑ PR (merge commit)
develop ──●───────────────●───────────────●────────┘
           \              ↑ squash        ↑ squash
            └─ t06-transacao-manual       └─ t07-listar-filtrar
```

1. Escolher **uma** issue (coluna "A fazer"), mover para "Em andamento".
2. Atualizar a `develop` e criar a branch a partir dela.
3. Desenvolver com commits pequenos.
4. Abrir PR para `develop`.
5. Com CI verde e checklist cumprido, fazer **squash merge** para `develop`.
6. Apagar a branch (local e remota) e mover a issue para "Concluído".

```bash
git checkout develop
git pull origin develop
git checkout -b t06-transacao-manual
# ... trabalho e commits ...
git push -u origin t06-transacao-manual
```

Para manter a branch atualizada durante o trabalho, trazer a `develop` para ela:

```bash
git fetch origin
git rebase origin/develop      # ou: git merge origin/develop
```

(Antes do primeiro PR, `rebase` é seguro. Depois que o PR está aberto e revisado, prefira `merge` para não reescrever
histórico já compartilhado.)

### Release: `develop` → `main`

Quando a `develop` estiver pronta para o MVP (marco concluído e critérios do plano atendidos):

1. Abrir PR `develop` → `main` com título `release: MVP vX.Y.Z`.
2. CI verde e checklist de release (seção 6) conferido.
3. **Merge commit** (não squash), para preservar o histórico dos squashes de cada issue.
4. Criar a tag na `main`: `git tag -a v0.1.0 -m "MVP"` e `git push origin v0.1.0`.

Versionamento: `v0.x.y` até o MVP estar publicado; depois, [SemVer](https://semver.org/lang/pt-BR/).

### Correção urgente (hotfix)

Se houver bug crítico na `main`: criar `hotfix/<descricao>` a partir da `main`, PR para `main` e, logo depois, trazer a
correção para a `develop` (PR `main` → `develop`). Caso raro: no MVP, preferir corrigir pela `develop`.

---

## 2. Nome de branches

Formato: **`t<ID>-<descricao-curta>`** para tarefas do plano (T01 a T20), em minúsculas, palavras separadas por hífen,
sem acento.

| Situação                          | Formato                          | Exemplo                       |
|-----------------------------------|----------------------------------|-------------------------------|
| Tarefa do plano                   | `t<ID>-<descricao>`              | `t06-transacao-manual`        |
| Issue fora do plano (bug, ajuste) | `issue-<numero>-<descricao>`     | `issue-42-corrige-total-mes`  |
| Correção urgente na `main`        | `hotfix/<descricao>`             | `hotfix/chave-jwt-expirada`   |

Regras: máximo de ~40 caracteres; a branch trata **uma** issue; nunca reutilizar a branch de uma issue já concluída.

---

## 3. Commits

Padrão [Conventional Commits](https://www.conventionalcommits.org/pt-br/):

```
<tipo>(<escopo opcional>): <descrição no imperativo, minúscula, sem ponto final>

[corpo opcional: o quê e por quê]

[rodapé opcional: Refs #12 / Closes #12]
```

### Tipos

| Tipo       | Uso                                                           |
|------------|---------------------------------------------------------------|
| `feat`     | Nova funcionalidade                                           |
| `fix`      | Correção de bug                                               |
| `refactor` | Mudança de código sem alterar comportamento                   |
| `test`     | Criação ou ajuste de testes                                   |
| `docs`     | Documentação (README, plano, ADRs)                            |
| `chore`    | Tarefas de manutenção (dependências, configuração, scripts)   |
| `build`    | Build, Maven, Docker, Flyway (estrutura de migrations)        |
| `ci`       | GitHub Actions e pipeline                                     |
| `perf`     | Melhoria de desempenho                                        |
| `style`    | Formatação sem mudar lógica                                   |

### Escopos sugeridos

`auth`, `transacao`, `categoria`, `normalizacao`, `dashboard`, `db`, `api`, `front`, `ci`, `docs`.

### Exemplos

```
feat(transacao): registra transação manual com sinal por tipo
fix(dashboard): corrige soma de receitas ignorando "não conta"
test(db): cobre FK composta entre transação e categoria
docs: adiciona ADR-005 sobre categorização manual no MVP
ci: executa testes do back-end a cada push
```

### Regras

- Commits **pequenos e atômicos**: uma ideia por commit.
- Idioma: português, de forma consistente.
- Primeira linha com no máximo ~72 caracteres.
- Mudança que quebra compatibilidade: `feat(api)!: ...` e explicar no corpo com `BREAKING CHANGE:`.
- Nunca commitar: segredos, chaves JWT, `.env`, dumps ou dados financeiros reais.

> Como o merge é **squash**, o histórico da `develop` terá **um commit por issue**. Os commits da branch podem ser
> simples, mas o **título do PR** vira a mensagem final e **deve seguir o padrão acima**.

---

## 4. Issues (as tarefas do GitHub Projects)

Cada tarefa do plano (T01 a T20) vira **uma issue**. Trabalho fora do plano também vira issue antes de ser feito.

### Título

`T06 — Registrar transação manual com aviso de duplicata` (tarefas do plano) ou `Bug: total do mês ignora estorno`
(demais casos).

### Corpo (modelo)

```markdown
## Objetivo
O que será entregue e por quê (1 a 3 linhas).

## Depende de
- #<issue> / T05

## Requisitos e regras relacionados
RF-02, RN-01, RN-10 (referência à especificação)

## Pronto quando
- [ ] critério 1 (copiado da coluna "Pronto quando" do plano)
- [ ] critério 2

## Notas
Decisões, riscos, links.
```

### Labels

| Grupo   | Labels                                                                 |
|---------|------------------------------------------------------------------------|
| Tipo    | `feature`, `bug`, `docs`, `chore`, `test`                              |
| Área    | `back-end`, `front-end`, `banco`, `infra`, `segurança`, `privacidade`  |
| Etapa   | `etapa-A` a `etapa-F` (conforme seção 9 do plano)                      |
| Estado  | `bloqueada`, `precisa-decisão`                                         |

### Milestones

Um por marco do plano: `M0 Fundação`, `M1 Lançamento manual`, `M2 Categorizar manualmente`, `M3 Analisar`,
`M4 Preparar release`, `M5 Validar`.

---

## 5. GitHub Projects (Kanban)

Colunas: **Backlog · A fazer · Em andamento · Concluído**.

| Regra                  | Descrição                                                                                                  |
|------------------------|------------------------------------------------------------------------------------------------------------|
| Limite de WIP          | **Uma** issue em "Em andamento" por vez                                                                    |
| Backlog → A fazer      | Issue com dependências já concluídas e "Pronto quando" definido                                            |
| A fazer → Em andamento | Ao criar a branch                                                                                          |
| Em andamento → Concluído | Ao concluir o squash merge na `develop` (a issue fecha automaticamente via `Closes #N` no PR)           |
| Issue bloqueada        | Fica na coluna atual com label `bloqueada` e comentário explicando o bloqueio                              |

Automação recomendada no Projects: ao abrir PR vinculado, mover para "Em andamento"; ao fechar a issue, mover para
"Concluído".

**Rotina por sessão (do plano, seção 6.4):** escolher 1 tarefa → conferir dependências → definir o resultado esperado →
implementar → verificar "pronto quando" → registrar bloqueios e definir o próximo passo.

---

## 6. Pull requests

### Regras

- Todo PR vai de `t06-...` (ou similar) para **`develop`**, exceto o de release (`develop` → `main`).
- **Um PR por issue**, pequeno e focado. Se ficar grande, dividir a issue.
- **Título** no padrão de commit: `feat(transacao): registra transação manual com aviso de duplicata`.
- Vincular a issue no corpo: `Closes #6`.
- Merge somente com **CI verde** e checklist completo.
- Tipo de merge: **squash** para `develop`; **merge commit** para `main`.
- Marcar "Delete branch after merge".

### Modelo de PR (`.github/pull_request_template.md`)

```markdown
## O que foi feito
Resumo objetivo.

Closes #

## Como testar
Passos ou comandos (`./mvnw test`, `npm test`, etc.).

## Checklist (definição de pronto)
- [ ] Critérios "Pronto quando" da issue atendidos
- [ ] Testes escritos e passando
- [ ] Sem segredo, chave ou dado real no código, nos logs ou nos testes
- [ ] Logs sem descrição, valor, senha ou token (RNF-03)
- [ ] Documentação atualizada (README, plano ou ADR, se aplicável)
- [ ] Migrations Flyway novas **não editam** migrations já aplicadas
- [ ] Branch atualizada com a `develop`

## Observações
Riscos, decisões, pontos para atenção.
```

### Checklist específico do PR de release (`develop` → `main`)

- [ ] Todas as issues do marco concluídas
- [ ] Critérios de conclusão do MVP (plano, seção 3.3) conferidos
- [ ] Testes de integração e de isolamento entre usuários passando
- [ ] Bloqueios de release (plano, seção 2.5) concluídos, se houver dados de terceiros
- [ ] README e documentação atualizados
- [ ] Tag criada após o merge

Como o projeto é individual, a revisão é uma **autorrevisão**: ler o diff completo no GitHub antes de fazer o merge.

---

## 7. Proteção de branches (configurar no GitHub)

Em *Settings → Branches*, criar regras para `main` e `develop`:

- Exigir pull request antes do merge (sem push direto).
- Exigir que os checks do CI passem (GitHub Actions) antes do merge.
- Exigir branch atualizada antes do merge.
- Bloquear force push e exclusão da branch.
- Em *Settings → General → Pull Requests*: habilitar **squash merging** (como padrão, usando título do PR) e **merge
  commit**; desabilitar rebase merge; habilitar "Automatically delete head branches".

> Atenção: o merge `develop` → `main` precisa de **merge commit**. Como o padrão do repositório será squash, selecionar
> manualmente "Create a merge commit" nesse PR.

---

## 8. Definição de pronto

Uma issue só vai para "Concluído" quando:

1. Critérios "Pronto quando" atendidos.
2. Testes passando (local e CI).
3. Sem segredo ou dado real no código.
4. Documentação atualizada.
5. Integrada à `develop` por squash merge.

---

## 9. Arquivos de apoio sugeridos

```
.github/
├── pull_request_template.md       # modelo da seção 6
├── ISSUE_TEMPLATE/
│   └── tarefa.md                  # modelo da seção 4
└── workflows/
    └── ci.yml                     # build e testes a cada push (T01)
.gitignore                         # inclui .env, *.pem, *.key, target/, node_modules/
CONTRIBUTING.md                    # este arquivo
```