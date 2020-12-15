# Trabalho Individual - GCES - 2020/1

[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=rogerioo_Trabalho-Individual-2020-1_api&metric=sqale_rating)](https://sonarcloud.io/dashboard?id=rogerioo_Trabalho-Individual-2020-1_api)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=rogerioo_Trabalho-Individual-2020-1_client&metric=sqale_rating)](https://sonarcloud.io/dashboard?id=rogerioo_Trabalho-Individual-2020-1_client)

A Gestão de Configuração de Software é parte fundamental no curso de GCES, e dominar os conhecimentos de configuração de ambiente, containerização, virtualização, integração e deploy contínuo tem se tornado cada vez mais necessário para ingressar no mercado de trabalho.

Nesse contexto que se insere esse trabalho que fez toda a gerência deste projeto.

O sistema se trata de uma aplicação Web, cuja funcionalidade consiste na pesquisa e exibição de perfis de usuários do GitHub, que é composta de:

- Front End escrito em Javascript, utilizando os frameworks Vue.JS e Quasar;
- Back End escrito em Ruby on Rails, utilizado em modo API;
- Banco de Dados PostgreSQL;

## 1. Containerização

Os módulos de execução do projeto foram todos divididos em containers (módulos) separados, sendo:

- API: usando uma imagem customizada do docker definido pela [Dockerfile](https://github.com/rogerioo/Trabalho-Individual-2020-1/blob/master/api/Dockerfile), tendo como base a do [ruby](https://hub.docker.com/_/ruby). A configuração do entrypoint se deu por um comportamento errático do docker-compose que falhava ao tentar rodar a imagem.

- Client: usando uma imagem customizada do docker definido pela [Dockerfile](https://github.com/rogerioo/Trabalho-Individual-2020-1/blob/master/client/Dockerfile), tendo como base a do [node](https://hub.docker.com/_/node)

- DB: usando a imagem oficial do [postgres](https://hub.docker.com/_/postgres)

Com o módulo de cada um definido foi usado o [docker-compose](https://github.com/rogerioo/Trabalho-Individual-2020-1/blob/master/docker-compose.yml) para poder gerenciar esses containers, gerenciando a network de comunicação entre eles, variáveis de ambiente, dependência entre os módulos e rastreio de arquivos (volumes).

## 2. Integração Contínua

A integração contínua foi feita usando o **actions** do github. Foram definidos dois workflows (pipelines) para cada um dos módulos da aplicação (api e client), o [CI API](https://github.com/rogerioo/Trabalho-Individual-2020-1/blob/master/.github/workflows/ci_api.ym) e o [CI Client](https://github.com/rogerioo/Trabalho-Individual-2020-1/blob/master/.github/workflows/ci_client.ym). Ambos possuem 3 passos, sendo cada um de acordo com a necessidade da aplicação. Foi usado o próprio docker para rodar os testes ([api](https://github.com/rogerioo/Trabalho-Individual-2020-1/blob/master/.github/workflows/ci_api.yml#L34) e [client](https://github.com/rogerioo/Trabalho-Individual-2020-1/blob/master/.github/workflows/ci_client.yml#L31)), sonnarcloud para avaliação de qualidade estática de código ([api](https://sonarcloud.io/dashboard?id=rogerioo_Trabalho-Individual-2020-1_api) e [client](https://sonarcloud.io/dashboard?id=rogerioo_Trabalho-Individual-2020-1_client)) e o [dockerhub](https://hub.docker.com/repository/docker/rogerioo/trabalho-individual-2020-1) para deploy das imagens. Vale ressaltar que os projetos do sonarcloud foram definidos como monorepos, vários serviços contidos em um mesmo repositório, fazendo com que a avaliação de cada um seja o mais fidedigna possível.

- O [CI API](https://github.com/rogerioo/Trabalho-Individual-2020-1/blob/master/.github/workflows/ci_api.yml) só roda caso haja alguma modificação dentro da pasta ```api```. Tentou-se configura o *coverage report* do sonarcloud para mostrar a cobertura de testes. Contudo essa ferramente não possui uma integração simples para tal tarefa, pois por se usar o docker para gerar o arquivo de coberturas, os caminhos absolutos para cada arquivo analisado conflitam com o caminho de arquivos do sonarcloud, pois são absolutos, fora que o padrão de arquivo usado ser fora do atual da comunidade do [SimpleCov](https://github.com/simplecov-ruby/simplecov) do Ruby. São três os passos, o build_and_tests, code_quality, deploy:

  - **build_and_tests**:
    1. Roda o compose da api para ver se a aplicação continua funcionando

    2. Roda os comandos de definição do banco de dados

    3. Roda os testes da API

    4. Sobe o coverage dos tests como artefato do job para ser usado por outro job

  - **code_quality**: é dependente do seu anterior pois espera pelo arquivo de report
      1. Resgata o arquivo de report para usar com o sonar cloud

      2. Roda o sonar cloud para avaliação do código

  - **deploy**: é dependente do seu anterior pois só deve ser rodado caso os anteriores tenham sucesso.
      1. Faz o login no dockerhub

      2. Faz o build da imagem

      3. Sobe para o [repositório](https://hub.docker.com/repository/docker/rogerioo/trabalho-individual-2020-1) do dockerhub

- O [CI Client](https://github.com/rogerioo/Trabalho-Individual-2020-1/blob/master/.github/workflows/ci_client.yml) só roda caso haja alguma modificação dentro da pasta ```client```.  São três os passos, o build_and_tests, code_quality, deploy:

  - **build_and_tests**:
    1. Roda o compose do client para ver se a aplicação continua funcionando

    2. Roda os testes da API

  - **code_quality**:
      1. Roda o sonar cloud para avaliação do código

  - **deploy**: é dependente dos anteriores pois só deve ser rodado caso tenham sucesso.
      1. Faz o login no dockerhub

      2. Faz o build da imagem

      3. Sobe para o [repositório](https://hub.docker.com/repository/docker/rogerioo/trabalho-individual-2020-1) do dockerhub

O controle de exigência que a pipeline não esteja quebrada é feito pelo próprio github que faz tal verificação.
