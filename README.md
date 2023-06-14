# «Crypto node»

[Официальный репозиторий ноды (Pathfinder)](https://github.com/eqlabs/pathfinder)

## Чекпоинты по уровню сложности:

:white_check_mark: - Выполнено.

### Light
1. :white_check_mark: Создать ноду любым удобным способом: в облаке или локально через Vagrant. Запланировать две виртуальные машины, первая для самой ноды (node1), вторая с системой мониторинга (monitoring).
2. :white_check_mark: Зарегистрировать приложение в сервисе Academy, если планируете получение наград в будущем.
3. :white_check_mark: Установить докер на node1 и запустить ноду через docker-compose.
4. :white_check_mark: Настроить dockerfile инструкцию HEALTHCHECK и добавить проверку в проект.
5. :white_check_mark: Написать Ansible-Playbook для развертывания приложения и вынести в отдельную Ansible Role атомарные операции.

### Medium
1. :white_check_mark: Установить на виртуалку monitoring Grafana. Loki. Prometheus. Установить на ноду Prometheus-exporter и настроить сбор метрик на работоспособность контейнера с нодой.
2. :white_check_mark: Написать отдельные роли для развертывания системы мониторинга Grafana, Loki, Prometheus.
3. Написать Ansible Role для Prometheus-exporter и настроить сбор метрик на работоспособность контейнера с нодой.
4. Виртуализировать метрики через Grafana.
   
### Hard
1. Развернуть несколько нод и систему мониторинга в облаке с помощью Terraform (можно использлвать любое облако на ваш выбор).
2. Настроить систему оповещений при достижении критических событий (заканчивается место на ноде или упал контейнер). Оповещения настроить в телеграмм.
3. Сделать CI/CD-пайплайн для развертывания нод и автоматизировать тестирование ролей в репозитории.
4. Развернуть ноды в облачном Kubernetes на ваш выбор. Предусмотреть автомасштабирование нод в зависимости от потребляемых ими ресурсов.



### Light
1. Создать ноду любым удобным способом: в облаке или локально через Vagrant. Запланировать две виртуальные машины, первая для самой ноды (node1), вторая с системой мониторинга (monitoring).

![Ссылка 1](https://github.com/Firewal7/crypto-project/blob/main/image/1.0.jpg)

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

```
└─# ansible-playbook playbook.yml                                       

PLAY [node1] ********************************************************************************************************

TASK [Install docker packages] **************************************************************************************
ok: [node1-01] => (item=apt-transport-https)
ok: [node1-01] => (item=ca-certificates)
ok: [node1-01] => (item=curl)
ok: [node1-01] => (item=software-properties-common)

TASK [Add Docker s official GPG key] ********************************************************************************
ok: [node1-01]

TASK [Verify that we have the key with the fingerprint] *************************************************************
ok: [node1-01]

TASK [Set up the stable repository] *********************************************************************************
ok: [node1-01]

TASK [Update apt packages] ******************************************************************************************
changed: [node1-01]

TASK [Install docker] ***********************************************************************************************
ok: [node1-01]

TASK [Add remote "ubuntu" user to "docker" group] *******************************************************************
ok: [node1-01]

TASK [Install docker-compose] ***************************************************************************************
ok: [node1-01]

TASK [Start container with healthstatus] ****************************************************************************
changed: [node1-01]

PLAY RECAP **********************************************************************************************************
node1-01                   : ok=9    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```
```
# ssh user@158.160.15.227

user@node1:~$ sudo docker ps
CONTAINER ID   IMAGE                      COMMAND                  CREATED              STATUS                                 PORTS                    NAMES
49216ab5bc84   eqlabs/pathfinder:latest   "/usr/bin/tini -- /u…"   About a minute ago   Up About a minute (health: starting)   0.0.0.0:9545->9545/tcp   pathfinder
```
### Medium
1. Установить на виртуалку monitoring Grafana. Loki. Prometheus. Установить на ноду Prometheus-exporter и настроить сбор метрик на работоспособность контейнера с нодой.

#### Установил на VM monitoring: Grafana, Prometheus, Loki. 

#### Установил на VM node1: Node-exporter (собирает метрики операционной системы, передаёт Prometheus), Promtail (агент, передающий содержимое локальных логов на Loki).

![Ссылка 3](https://github.com/Firewal7/crypto-project/blob/main/image/1.3.jpg)

![Ссылка 4](https://github.com/Firewal7/crypto-project/blob/main/image/1.4.jpg)

![Ссылка 5](https://github.com/Firewal7/crypto-project/blob/main/image/1.5.jpg)

2. Написать отдельные роли для развертывания системы мониторинга Grafana, Loki, Prometheus.
3. Написать Ansible Role для Prometheus-exporter и настроить сбор метрик на работоспособность контейнера с нодой.
4. Виртуализировать метрики через Grafana.
   
### Hard
1. Развернуть несколько нод и систему мониторинга в облаке с помощью Terraform (можно использлвать любое облако на ваш выбор).
2. Настроить систему оповещений при достижении критических событий (заканчивается место на ноде или упал контейнер). Оповещения настроить в телеграмм.
3. Сделать CI/CD-пайплайн для развертывания нод и автоматизировать тестирование ролей в репозитории.
4. Развернуть ноды в облачном Kubernetes на ваш выбор. Предусмотреть автомасштабирование нод в зависимости от потребляемых ими ресурсов.
