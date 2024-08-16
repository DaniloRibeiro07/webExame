# WebExame

O melhor sistema de gerenciamento de exames. 

Projeto desenvolvido durante o curso na Rebase Labs.

Com este projeto, é possível consultar uma lista de exames cadastrada no sistema, vê detalhes de um exame contendo dados do paciente, médico e resultados, buscar um exame a partir de um token e importar Exames em formato CSV.

# Requisitos

Para rodar o projeto é necessário que você possua o docker instalado.
Sem o docker, os passos ensinados serão desnecessários.
O projeto foi desenvolvido e testado em uma máquina Ubuntu 24.04

# Instalação e execução

- Clone o projeto (necessário possuir o git instalado na máquina)

```sh
  git clone https://github.com/DaniloRibeiro07/webExame.git
```

- Entre no projeto

```sh
  cd webExame
```

- Script para executar testes na aplicação:

```sh
  bin/test.sh
```
Caso de algum erro devido ao terminal, erro de bash ou zsh, copie o código dentro do arquivo bin/start.sh e cole no seu terminal, lembre-se de estar dentro da pasta do projeto. Essa mesma observação serve para os scripts posteriores.

- Script para executar a aplicação:

```sh
bin/start.sh
```

Acesse o link [localhost:4567](http://localhost:4567) para visualizar a aplicação funcionando

- (Opcional) Script para popular o banco de dados da aplicação com 9 exames:

```sh
bin/seed.sh
```

- (Extra) Script para resetar (excluir e criar) o banco de dados da aplicação:

```sh
bin/reset_bd.sh
```

- (Extra) Script para resetar as tabelas do banco de dados da aplicação:

```sh
bin/truncate_bd.sh
```

# Principais Tecnologias Utilizadas

- Ruby 3.2.5
- Sinatra
- Bootstrap
- Docker

## Mais informações na documentação do projeto: [Documentação](https://github.com/DaniloRibeiro07/webExame/wiki) 