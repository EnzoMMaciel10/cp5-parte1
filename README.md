# Mercado Express — CP5, Parte 1

Aplicação web para gerenciamento de produtos de um mercado, desenvolvida para o **Checkpoint 5 de Java Advanced da FIAP**. Esta parte reúne o catálogo, o CRUD de produtos, o cadastro de usuários e o controle de acesso com Spring Security. A parte de pedidos pertence a um projeto e repositório separados (**Parte 2**).

## Integrantes

- Enzo Monteiro Maciel - RM563734
- Matheus de Almeida Sousa - RM563557
- Paulo Estalise - RM563811
- Gabriel Bebé Silva - RM562012
- Emanuel Italo - RM561337

## Funcionalidades

- Página inicial em `index.html` e interface em português, construída com Thymeleaf e CSS responsivo.
- Cadastro de usuários com validação de nome, e-mail único e senha de pelo menos oito caracteres.
- Tela de login própria, diferente da página padrão do Spring Security, com autenticação por e-mail e senha.
- Dois perfis: `CLIENTE` consulta o catálogo e os detalhes; `ADMIN` também cadastra, edita e exclui produtos.
- Busca de produtos por parte do nome, sem diferenciar maiúsculas de minúsculas.
- CRUD de produtos persistido no PostgreSQL, com validação de preço, custo e estoque.
- Mensagens de confirmação e erro, saída da conta e página personalizada para acesso negado (HTTP 403).

## Tecnologias

Java 17, Spring Boot 4.0.8, Spring MVC, Spring Security, Spring Data JPA, Bean Validation, Thymeleaf, Thymeleaf Extras Spring Security, PostgreSQL, Maven e Lombok. O projeto foi desenvolvido no **IntelliJ IDEA**.

## Como funciona

Ao abrir `/`, o visitante vê a página inicial. Se ainda não possui uma conta, acessa `/cadastro`, informa nome, e-mail e senha e passa a ter o perfil `CLIENTE`. A senha é armazenada com hash BCrypt. Após o cadastro, o usuário é encaminhado à tela de login; um login bem-sucedido abre `/mercado`.

O cliente pode listar, buscar e consultar os detalhes dos produtos. Os links administrativos são exibidos somente para `ADMIN` e as rotas de criação, edição e exclusão também são protegidas no servidor. Portanto, tentar abrir uma rota administrativa diretamente com uma conta `CLIENTE` resulta em acesso negado.

O cadastro público sempre cria usuários `CLIENTE`. O perfil `ADMIN` deve ser atribuído por quem administra o banco de dados a uma conta autorizada; a aplicação não oferece uma rota pública para promover usuários.

### Exemplo de uso

1. Um administrador cadastra **Arroz integral**, tipo **Alimento**, setor **Mercearia**, embalagem **5 kg**, preço **R$ 25,90**, custo **R$ 18,00** e estoque **30**.
2. O produto aparece na lista e pode ser encontrado pesquisando por `arroz`.
3. Qualquer usuário autenticado pode abrir **Detalhes** para consultar as informações do produto.
4. O administrador pode atualizar os dados ou excluir o produto. O cliente não vê esses controles e não tem permissão para acessar as rotas correspondentes.

## Rotas e permissões

| Método | Rota | Função | Acesso |
| --- | --- | --- | --- |
| GET | `/` | Página inicial | Público |
| GET/POST | `/cadastro` | Formulário e criação de conta | Público |
| GET/POST | `/login` | Tela própria e autenticação | Público |
| POST | `/logout` | Encerrar sessão | Autenticado |
| GET | `/mercado` | Listar e buscar produtos | CLIENTE ou ADMIN |
| GET | `/mercado/detalhes/{id}` | Detalhes do produto | CLIENTE ou ADMIN |
| GET | `/mercado/novo` | Formulário de produto | ADMIN |
| POST | `/mercado` | Criar produto | ADMIN |
| GET/POST | `/mercado/editar/{id}` | Formulário e atualização | ADMIN |
| POST | `/mercado/excluir/{id}` | Excluir produto | ADMIN |

## Dados persistidos

O PostgreSQL guarda os produtos na tabela `tds_sec_mvc_tb_mercado` e os usuários na tabela `tds_users_mercado`. O produto possui nome, tipo, setor, tamanho/embalagem, preço de venda, custo de aquisição e quantidade em estoque. O usuário possui nome, e-mail único, senha criptografada e perfil.

As entidades JPA e os repositórios Spring Data fazem a persistência. A configuração local está em `src/main/resources/application.yaml`; o Hibernate está configurado com `ddl-auto: update` para criar ou atualizar as tabelas durante o desenvolvimento.

## Executar localmente

Pré-requisitos: **JDK 17**, **PostgreSQL** em execução na porta `5432` e o banco `cp5` criado. A configuração atual usa o usuário PostgreSQL `postgres` e lê a senha da variável de ambiente `DB_PASSWORD`; ela não deve ser gravada no Git.

No IntelliJ IDEA:

1. Abra a pasta deste projeto como projeto Maven e aguarde a importação das dependências.
2. Configure o SDK do projeto e da execução como **Java 17**.
3. Crie o banco `cp5` no PostgreSQL, se ele ainda não existir.
4. Na configuração de execução de `Cp5Application`, adicione a variável de ambiente `DB_PASSWORD` com a senha do usuário PostgreSQL local.
5. Execute `Cp5Application` e acesse `http://localhost:8080/`.

Também é possível iniciar pela linha de comando, desde que `DB_PASSWORD` já esteja configurada no ambiente:

```powershell
.\mvnw.cmd spring-boot:run
```

Não execute a Parte 1 e a Parte 2 simultaneamente na mesma porta `8080` sem alterar a porta de uma delas.

## Organização do código

```text
src/main/java/br/com/fiap/cp5/
├── config/       # Segurança e codificação de senhas
├── controller/   # Páginas, cadastro, login e CRUD
├── dto/          # Dados recebidos no cadastro
├── model/        # Entidades e perfis
├── repository/   # Acesso ao PostgreSQL
└── service/      # Regras de negócio
src/main/resources/
├── static/       # CSS e imagem de fundo
├── templates/    # Páginas Thymeleaf
└── application.yaml
```

## Verificação funcional

1. Abra a página inicial e a tela personalizada de login.
2. Cadastre uma conta nova; verifique a mensagem de sucesso e entre com essa conta.
3. Como `CLIENTE`, consulte a lista, pesquise um produto e abra os detalhes. Tente acessar `/mercado/novo` diretamente e confirme que o servidor nega o acesso.
4. Entre com uma conta `ADMIN`, cadastre um produto e confira-o na lista e no PostgreSQL.
5. Edite o produto, confira a atualização e depois exclua-o.
6. Saia da conta e confirme que as páginas restritas exigem novo login.

O teste automatizado atualmente incluído no projeto é o teste básico de inicialização do contexto Spring; os passos acima documentam a verificação manual dos fluxos principais.

## Capturas para a entrega

**Ainda é preciso adicionar prints atuais**, tirados após a execução da versão final. O enunciado solicita imagens e explicações no README, principalmente do desenvolvimento e da implementação do login. Sugestão de capturas: página inicial, cadastro, login personalizado, catálogo, formulário de produto, detalhes, acesso negado para `CLIENTE` e tabela de produtos no PostgreSQL. Guarde-as em `docs/prints/` e insira aqui os links Markdown correspondentes. O print da configuração final do Spring Initializr e das dependências também deve acompanhar a entrega.

## Publicação

O link de produção será acrescentado após o deploy. A configuração local usa `localhost` para o PostgreSQL; para publicar a aplicação, será necessário fornecer as credenciais e o endereço do banco do ambiente de produção por variáveis de ambiente, sem expor senhas no repositório. Depois do deploy, teste novamente o login, os dois perfis e o CRUD no endereço publicado.
