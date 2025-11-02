# Desafio C2S

Este projeto é uma sugestão de implementação do [desafio proposto](CHALLENGE.md) pela C2S.

## Organização do Projeto

Este projeto está organizado em um único artefato Ruby on Rails.

Vale a pena destacar alguns pontos:

- O processamento do email se dá de forma assincrona, sendo a classe [EmailProcessoJob](app/jobs/email_processor_job.rb) responsável pelo enfileiramento do processo.
- Um vez que o job inicia, a classe [EmailProcessorService](app/services/email_processor_service.rb) se torna responsável pelo processamento do email.
- Lendo o conteúdo do email, o serviço seleciona o parser correto. 
- Não havendo inconsistências entre o parsing e a extração de dados, um log com os dados extraidos e status sucesso será gerado. Caso contrário, um log de erro será gerado.
- Ambos os parsers [ForncedoerA](app/services/parsers/fornecedor_a.rb) e [ParceiroB](app/services/parsers/parceiro_b.rb) são classes especializadas da classe [Base](app/services/parsers/base.rb).
- Para um novo parser, criar um parser baseado na classe mãe e criar um dicionário chave valor e implementar o método parse!
- Foi desenvolvido uma tarefa do tipo rake, que limpa os logs com mais de trinta dias, podendo ser configurado pela variavel de ambiente DAYS que pode ser editado no arquivo [env.docker.local](env.docker.local)

## Principais tecnologias
<table>
  <tr>
    <td style="vertical-align: center; text-align: left">
      <a href="https://www.docker.com">
        <img height="28" width="28" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/docker/docker-plain-wordmark.svg">
        Docker
      </a>
    </td>
    <td style="vertical-align: center; text-align: left">
      <a href="https://www.rubyonrails.org">
        <img height="28" width="28" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/rails/rails-plain.svg">
        Ruby on Rails
      </a>
    </td>
    <td style="vertical-align: center;text-align: left;">
      <a href="https://rspec.info/">
        <img height="28" width="28" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/rspec/rspec-original.svg">
        RSpec
      </a>
    </td>
    <td style="vertical-align: center;text-align: left;">
      <a href="https://www.postgresql.org">
        <img height="28" width="28" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/postgresql/postgresql-plain.svg">
        PostgreSQL
      </a>
    </td>
    <td style="vertical-align: center;text-align: left;">
      <a href="https://www.postgresql.org">
        <img height="28" width="28" src="https://sidekiq.org/assets/sidekiq.png">
        Sidekiq
      </a>
    </td>
  </tr>
</table>

## Principais gems
  - RSpec
  - Rubucop
  - Coverage
  - Mail
  - Sidekiq
  - Bootstrap

## Requesitos
Para executar esse projeto em sua máquina local, os requesitos são uma boa conexão com a Internet, docker e docker-compose instaladas.

## 📦 Setup
### 1. Clone o repositório do Github:
```bash
$ git clone https://github.com/GeorgeLMaluf0579/desafil_c2s.git && cd desafil_c2s
```
### 2. Construa os containers do docker
```bash
$ docker-compose up --build
```
Este processo pode demorar um pouco dependendo do seu computador e da sua conexão com a internet.

### 3. Configurar o banco de dados
```bash
$ docker-compose run --rm rails rails db:drop db:create db:migrate
```

## Execução do Projeto
Depois de executar os procedimentos de configuração, utilize a seguinte linha de comando:
```bash
$ docker-compose up
```
Abra o seu navegador de preferencia apontando para a seguinte url:
[http://localhost:3000](http://localhost:3000)

## 🤖 Testes Automatizados e cobertura de código
```bash
$ docker-compose run --rm rails bundle exec rspec
```
Uma pasta chamada `coverage`será criada ou atualizada dentro da pasta do projeto.

## 🧹 Limpeza dos logs
Para executar a limpeza dos logs, no ambiente de desenvolvimento atual, execute a seguinte linha de comando:
```bash
$ docker-compose run --rm rails rails logs:cleanup
```
Obs: em ambiente de producão essa tarefa pode ser agendada via crond.

## 👨🏻‍💻 Autor
Made by George Luiz 'Maverick' Maluf

<b> 📫 How to reach me</b>
<div>
  <a href="https://www.linkedin.com/in/%F0%9F%91%A8%F0%9F%8F%BB%E2%80%8D%F0%9F%92%BB-george-l-maluf-24225733/"><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white"></a>
  <a href="https://api.whatsapp.com/send?phone=554298337945"><img src="https://img.shields.io/badge/WhatsApp-25D366?style=for-the-badge&logo=whatsapp&logoColor=white"></a>
  <a href="mailto:georgelmaluf286@gmail.com"><img src="https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white"></a>
</div>
