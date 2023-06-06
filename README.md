## «Crypto node»

## Чекпоинты по уровню сложности:

### Light
1. Создать ноду любым удобным способом: в облаке или локально через Vagrant. Запланировать две виртуальные мышины, первая для самой ноды (node1), вторая с системой мониторинга (monitoring).

![Ссылка 1](https://github.com/Firewal7/crypto-project/blob/main/image/1.1.jpg)

2. Зарегистрировать приложение в сервисе Academy, если планируете получение наград в будущем. 

![Ссылка 2](https://github.com/Firewal7/crypto-project/blob/main/image/1.2.jpg)

3. Установить докер на node1 и запустить ноду через docker-compose.
```
user@node1:~$ docker --version
Docker version 24.0.2, build cb74dfc
```
- Создаём docker-compose.yml
```
version: "3"
services:
  starknet-node:
    image: eqlabs/pathfinder:latest
    user: root
    restart: unless-stopped
    environment:
      - RUST_LOG=info
    env_file:
      - pathfinder-var.env
    volumes:
      - ./pathfinder:/usr/share/pathfinder/data
    ports:
      - 9545:9545
```
- Создаём pathfinder-var.env (со своим API)
```
PATHFINDER_ETHEREUM_API_URL=https://eth-goerli.g.alchemy.com/v2/https://eth-goerli.g.alchemy.com/v2/xIfcRx19SCf05gMKkEL7RJDexILs4ykB
```
4. Настроить dockerfile инструкцию HEALTHCHECK и добавить проверку в проект.

- Добавляем в docker-compose.yml 
```
     healthcheck:
      test: curl --fail http://localhost || exit 1
      interval: 60s
      retries: 5
      start_period: 20s
      timeout: 10s
```
```
                                                                                                               
 docker ps              
CONTAINER ID   IMAGE                      COMMAND                  CREATED          STATUS                             PORTS                                       NAMES
1e88e9f6511b   eqlabs/pathfinder:latest   "/usr/bin/tini -- /u…"   59 seconds ago   Up 58 seconds (health: starting)   0.0.0.0:9545->9545/tcp, :::9545->9545/tcp   crypto-project_starknet-node_1
```
5. Написать Ansible-Playbook для развертывания приложения и вынести в отдельную Ansible Role атомарные операции.

[Ansible-Playbook](https://github.com/Firewal7/crypto-project/blob/main/ansible/playbook.yml)


### Medium
1. Установить на виртуалку monitoring Grafana. Loki. Prometeus. Установить на ноду Prometeus-exporter и настроить сбор метрик на работоспособность контейнера с нодой.
2. Написать отдельные роли для развертывания системы мониторинга Grafana, Loki, Prometeus.
3. Написать Ansible Role для Prometeus-exporter и настроить сбор метрик на работоспособность контейнера с нодой.
4. Виртуализировать метрики через Grafana.
   
### Hard
1. Развернуть несколько нод и систему мониторинга в облаке с помощью Terraform (можно использлвать любое облако на ваш выбор).
2. Настроить систему оповещаний при достижении критических событий (заканчивается место на ноде или упал контейнер). Оповещания настроить в телеграмм.
3. Сделать CI/CD-пайплайн для развертывания нод и автоматизировать тетстирование ролей в репозитории.
4. Развернуть ноды в облачном Kubernetes на ваш выбор. Предусмотреть автомасштабирование нод в зависимости от потребляемых ими ресурсов.
