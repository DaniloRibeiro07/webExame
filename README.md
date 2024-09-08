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

- Comando para executar testes na aplicação:

```sh
docker compose up test
```
- Comando para executar a aplicação:

```sh
docker compose up start
```

Acesse o link [localhost:4567](http://localhost:4567) para visualizar a aplicação funcionando

- (Opcional) Comando para popular o banco de dados da aplicação com 9 exames:

```sh
docker compose up seed
```

- (Extra) Script para resetar (excluir e criar) o banco de dados da aplicação:

```sh
docker compose up reset_bd
```

- (Extra) Script para resetar as tabelas do banco de dados da aplicação:

```sh
docker compose up truncate_bd
```

# Principais Tecnologias Utilizadas

- Ruby 3.2.5
- Sinatra
- Bootstrap
- Docker

## Mais informações na documentação do projeto: [Documentação](https://github.com/DaniloRibeiro07/webExame/wiki) 