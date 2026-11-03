# Configuração do GitHub (passo a passo)

Guia da tarefa T01 para configurar o repositório do TrackFlow **sem CI**. Faça na ordem. Onde houver `<usuario>/<repo>`,
use os dados do seu repositório.

Resultado final: `develop` como branch padrão; `main` e `develop` protegidas (sem push direto); squash na `develop` e merge
commit na `main`; labels, milestones, Projects e issues prontos.

---

## Passo 1: garantir que a `develop` existe no remoto

No terminal, na pasta do projeto:

```bash
git branch -a
```

Se `remotes/origin/develop` **não** aparecer na lista:

```bash
git checkout main
git pull origin main
git checkout -b develop
git push -u origin develop
```

> Se o repositório remoto ainda estiver vazio (sem nenhum commit), faça antes um commit inicial na `main`
> (por exemplo, o `README.md`) e envie com `git push -u origin main`. Só depois crie a `develop` a partir dela.

## Passo 2: trocar a branch padrão para `develop`

1. No GitHub, abra o repositório e clique em **Settings** (aba no topo).
2. No menu da esquerda, clique em **General**.
3. Role até a seção **Default branch**.
4. Clique no ícone de setas (⇄) ao lado de `main`.
5. Escolha **`develop`** e clique em **Update**. Confirme em **I understand, update the default branch**.

Por que: o `Closes #6` escrito em um PR só fecha a issue automaticamente se o merge cair na branch padrão.

## Passo 3: configurar os tipos de merge do repositório

Ainda em **Settings → General**, role até **Pull Requests**:

1. **Allow merge commits:** marcado. Em *Default commit message*, deixe "Default message".
2. **Allow squash merging:** marcado. Em *Default commit message*, escolha **Pull request title**.
3. **Allow rebase merging:** **desmarcado**.
4. **Always suggest updating pull request branches:** opcional (marcar ajuda a manter a branch em dia).
5. **Automatically delete head branches:** **marcado** (apaga a branch da issue após o merge).

Role até o fim se houver botão e clique em **Save** (algumas opções salvam sozinhas).

## Passo 4: criar o ruleset de proteção da `develop`

1. **Settings → Rules → Rulesets**.
2. Clique em **New ruleset → New branch ruleset**.
3. Preencha:
    - **Ruleset Name:** `Protect develop`
    - **Enforcement status:** `Active`
    - **Bypass list:** deixe vazia.
4. Em **Target branches**:
    - Se já existir o alvo **All branches**, clique na lixeira ao lado dele para removê-lo.
    - Clique em **Add target → Include by pattern**, digite `develop` e confirme. (Não use "All branches": isso
      bloquearia as branches das suas issues.)
5. Em **Branch rules**, marque **apenas** estas:
    - ✅ **Restrict deletions**
    - ✅ **Block force pushes**
    - ✅ **Require a pull request before merging**
6. Dentro de *Require a pull request before merging*, clique em **Show additional settings** e ajuste:
    - **Required approvals:** `0` (você não pode aprovar o próprio PR; com 1, nenhum merge seria possível).
    - **Allowed merge methods:** deixe **somente Squash**.
    - Desmarque **Require an additional approval for unattributed Copilot pull requests**.
    - Demais opções: desmarcadas.
7. Deixe **desmarcados**: *Restrict creations*, *Restrict updates*, *Require linear history*, *Require deployments*,
   *Require signed commits*, **Require status checks to pass** (não há CI), *Require code scanning*, *Require code
   quality*, *Restrict code coverage* e **Automatically request Copilot code review**.
8. Clique em **Create**.

## Passo 5: criar o ruleset de proteção da `main`

Repita o passo 4 com estas diferenças:

- **Ruleset Name:** `Protect main`
- **Target branches:** *Include by pattern* → `main`
- **Allowed merge methods:** deixe **somente Merge** (o PR de release usa merge commit).

Todo o resto igual: *Restrict deletions*, *Block force pushes*, *Require a pull request before merging* com 0
aprovações, sem status checks.

> Atenção: com os dois rulesets ativos, **nem você consegue dar push direto** em `main` e `develop`. Isso é o desejado.
> Tudo, inclusive `CONTRIBUTING.md` e `README.md`, entra por branch e PR (veja o passo 9).

Se aparecer o aviso de que as regras não serão aplicadas por causa do plano/repositório privado: as regras de ruleset em
repositório privado exigem plano pago. Nesse caso, torne o repositório público ou siga o fluxo por disciplina.

## Passo 6: criar as labels

1. Clique em **Issues → Labels** (ou `/<usuario>/<repo>/labels`).
2. O GitHub traz algumas labels padrão. Pode deixá-las ou apagar as que não usar.
3. Clique em **New label** e crie, uma a uma (nome e cor livres):

| Grupo  | Labels                                                                     |
|--------|----------------------------------------------------------------------------|
| Tipo   | `feature`, `bug`, `docs`, `chore`, `test`                                  |
| Área   | `back-end`, `front-end`, `banco`, `infra`, `segurança`, `privacidade`      |
| Etapa  | `etapa-A`, `etapa-B`, `etapa-C`, `etapa-D`, `etapa-E`, `etapa-F`           |
| Estado | `bloqueada`, `precisa-decisão`                                             |

## Passo 7: criar os milestones

1. **Issues → Milestones → New milestone**.
2. Crie seis, sem data obrigatória:
   `M0 Fundação`, `M1 Lançamento manual`, `M2 Categorizar manualmente`, `M3 Analisar`, `M4 Preparar release`,
   `M5 Validar`.

## Passo 8: criar o quadro no GitHub Projects

1. Na página inicial do repositório (ou da sua conta), aba **Projects → New project**.
2. Escolha o modelo **Board** e dê o nome `TrackFlow`.
3. Renomear as colunas (status):
    - Clique na seta ao lado do título de uma coluna → **Edit details**/renomear, ou vá em **Settings do projeto →
      Status**.
    - Deixe exatamente: **Backlog**, **A fazer**, **Em andamento**, **Concluído** (remova "Todo", "In Progress", "Done"
      ou renomeie-os).
4. No projeto, clique em **⋯ → Settings → Manage access/Linked repositories** e **vincule o repositório** do TrackFlow.
5. Ainda em Settings do projeto, abra **Workflows** e ative:
    - **Item added to project** → status **Backlog**
    - **Item closed** → status **Concluído**
    - **Pull request merged** → status **Concluído**
6. Mover manualmente: **A fazer → Em andamento** (quando criar a branch).

## Passo 9: subir os arquivos de convenção (usando o fluxo)

Esse é o seu primeiro PR e serve de teste do fluxo. Coloque na pasta do projeto: `CONTRIBUTING.md`, `README.md`,
`docs/configuracao-github.md`, `docs/` com a especificação (plano v1.0), `.github/pull_request_template.md` e
`.github/ISSUE_TEMPLATE/tarefa.md`. Adicione também um `.gitignore` com pelo menos:

```
.env
*.pem
*.key
target/
node_modules/
```

Então:

```bash
git checkout develop
git pull origin develop
git checkout -b t01-convencoes-e-configuracao
git add .
git commit -m "docs: adiciona convenções, templates e guia de configuração do GitHub"
git push -u origin t01-convencoes-e-configuracao
```

No GitHub:

1. Clique em **Compare & pull request**.
2. Confira que **base: `develop`** e **compare: `t01-convencoes-e-configuracao`**.
3. No corpo, escreva `Closes #1` (depois de criar a issue da T01, passo 10).
4. Clique em **Create pull request**.
5. Leia a aba **Files changed** (autorrevisão).
6. Clique em **Squash and merge** → **Confirm squash and merge** → **Delete branch**.

Se o botão de merge só mostrar "Squash and merge", o ruleset da `develop` está funcionando.

Depois, atualize o local:

```bash
git checkout develop
git pull origin develop
git branch -d t01-convencoes-e-configuracao
```

## Passo 10: criar as issues T01 a T20

1. **Issues → New issue** (se houver o template `tarefa.md`, escolha-o).
2. Para cada tarefa da seção 9 do plano, preencha:
    - **Título:** `T06 — Registrar transação manual com aviso de duplicata`
    - **Corpo:** objetivo, depende de, requisitos relacionados, "pronto quando" (copie da tabela do plano).
    - **Labels:** tipo, área e etapa (ex.: `feature`, `back-end`, `etapa-B`).
    - **Milestone:** o marco correspondente (T01–T04 = M0; T05–T08 = M1; T09, T11, T12 = M2; T13–T15 = M3;
      T16–T19 = M4; T20 = M5).
    - **Projects:** selecione `TrackFlow`. Ela entra em **Backlog**.
3. Marque T10 como removida: não crie essa issue.
4. Mova para **A fazer** as issues já liberadas (T01 e T04).

Para facilitar, crie primeiro a T01, depois as demais por ordem.

## Passo 11: rotina a partir de agora

1. Mover a issue para **Em andamento** (somente uma por vez).
2. `git checkout develop && git pull origin develop && git checkout -b t06-transacao-manual`.
3. Trabalhar e fazer commits pequenos.
4. **Rodar os testes localmente** (`./mvnw test`, `npm test`).
5. `git push -u origin t06-transacao-manual` e abrir PR para `develop` com `Closes #<numero>`.
6. Autorrevisão e **Squash and merge**, apagando a branch.
7. A issue fecha sozinha e vai para **Concluído**.

## Passo 12: primeiro release (quando o MVP estiver pronto)

1. Rodar **todos** os testes na `develop` atualizada.
2. Abrir PR de **`develop` → `main`** com título `release: MVP v0.1.0`.
3. Conferir o checklist de release do `CONTRIBUTING.md`.
4. Fazer **Merge pull request** (merge commit). Esse é o único método permitido na `main`.
5. Criar a tag:

```bash
git checkout main
git pull origin main
git tag -a v0.1.0 -m "MVP"
git push origin v0.1.0
```

---

## Conferência final

- [ ] `develop` é a branch padrão
- [ ] Rulesets `Protect develop` (só squash) e `Protect main` (só merge) ativos, 0 aprovações, sem status checks
- [ ] Merge commit e squash habilitados; rebase desabilitado; exclusão automática de branches ligada
- [ ] Labels e milestones criados
- [ ] Projects com colunas Backlog / A fazer / Em andamento / Concluído e automações ativas
- [ ] Arquivos de convenção na `develop`
- [ ] Issues T01–T20 criadas (menos T10)