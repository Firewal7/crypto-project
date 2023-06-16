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
3. :white_check_mark: Написать Ansible Role для Prometheus-exporter и настроить сбор метрик на работоспособность контейнера с нодой.
4. :white_check_mark: Виртуализировать метрики через Grafana.
   
### Hard
1. :white_check_mark: Развернуть несколько нод и систему мониторинга в облаке с помощью Terraform (можно использлвать любое облако на ваш выбор).
2. Настроить систему оповещений при достижении критических событий (заканчивается место на ноде или упал контейнер). Оповещения настроить в телеграмм.
3. Сделать CI/CD-пайплайн для развертывания нод и автоматизировать тестирование ролей в репозитории.
4. Развернуть ноды в облачном Kubernetes на ваш выбор. Предусмотреть автомасштабирование нод в зависимости от потребляемых ими ресурсов.



### Light
1. :white_check_mark: Создать ноду любым удобным способом: в облаке или локально через Vagrant. Запланировать две виртуальные машины, первая для самой ноды (node1), вторая с системой мониторинга (monitoring).

![Ссылка 1](https://github.com/Firewal7/crypto-project/blob/main/image/1.0.jpg)

2. :white_check_mark: Зарегистрировать приложение в сервисе Academy, если планируете получение наград в будущем. 

![Ссылка 2](https://github.com/Firewal7/crypto-project/blob/main/image/1.2.jpg)

3. :white_check_mark: Установить докер на node1 и запустить ноду через docker-compose.
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
4. :white_check_mark: Настроить dockerfile инструкцию HEALTHCHECK и добавить проверку в проект.

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
5. :white_check_mark: Написать Ansible-Playbook для развертывания приложения и вынести в отдельную Ansible Role атомарные операции.

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
1. :white_check_mark: Установить на виртуалку monitoring Grafana. Loki. Prometheus. Установить на ноду Prometheus-exporter и настроить сбор метрик на работоспособность контейнера с нодой.

#### Установил на VM monitoring: Grafana, Prometheus, Loki. 

#### Установил на VM node1: Node-exporter (собирает метрики операционной системы, передаёт Prometheus), Promtail (агент, передающий содержимое локальных логов на Loki).

![Ссылка 3](https://github.com/Firewal7/crypto-project/blob/main/image/1.3.jpg)

![Ссылка 4](https://github.com/Firewal7/crypto-project/blob/main/image/1.4.jpg)

![Ссылка 5](https://github.com/Firewal7/crypto-project/blob/main/image/1.5.jpg)

2. :white_check_mark: Написать отдельные роли для развертывания системы мониторинга Grafana, Loki, Prometheus.

<details>
<summary>└─# ansible-playbook playbook.yml</summary>

PLAY [install utils] ******************************************************************************************************************************

TASK [docker_install : Install docker packages] ***************************************************************************************************
ok: [node1-01] => (item=apt-transport-https)
ok: [node1-01] => (item=ca-certificates)
ok: [node1-01] => (item=curl)
ok: [node1-01] => (item=software-properties-common)

TASK [docker_install : Add Docker s official GPG key] *********************************************************************************************
ok: [node1-01]

TASK [docker_install : Verify that we have the key with the fingerprint] **************************************************************************
ok: [node1-01]

TASK [docker_install : Set up the stable repository] **********************************************************************************************
ok: [node1-01]

TASK [docker_install : Update apt packages] *******************************************************************************************************
changed: [node1-01]

TASK [docker_install : Install docker] ************************************************************************************************************
ok: [node1-01]

TASK [docker_install : Add remote "ubuntu" user to "docker" group] ********************************************************************************
ok: [node1-01]

TASK [docker_install : Install docker-compose] ****************************************************************************************************
ok: [node1-01]

TASK [container_pathfinder : Start container with healthstatus] ***********************************************************************************
ok: [node1-01]

PLAY [install monitoring] *************************************************************************************************************************

TASK [grafana : Update package libfontconfig1] ****************************************************************************************************
ok: [monitoring-01]

TASK [grafana : Get Grafana deb] ******************************************************************************************************************
ok: [monitoring-01]

TASK [grafana : installed Grafana] ****************************************************************************************************************
changed: [monitoring-01]

TASK [grafana : start and enable grafana-server] **************************************************************************************************
ok: [monitoring-01]

TASK [prometheus : Get Prometheus distrib] ********************************************************************************************************
ok: [monitoring-01]

TASK [prometheus : Unarchive a file] **************************************************************************************************************
changed: [monitoring-01]

TASK [prometheus : Copy file prometheus.yml] ******************************************************************************************************
changed: [monitoring-01]

TASK [prometheus : Run Prometheus] ****************************************************************************************************************
changed: [monitoring-01]

TASK [loki : install dependencies] ****************************************************************************************************************
ok: [monitoring-01]

TASK [loki : Get Prometheus distrib] **************************************************************************************************************
ok: [monitoring-01]

TASK [loki : Unarchive a file] ********************************************************************************************************************
ok: [monitoring-01]

TASK [loki : Copy file] ***************************************************************************************************************************
ok: [monitoring-01]

TASK [loki : Change permissions] ******************************************************************************************************************
ok: [monitoring-01]

TASK [loki : Create a directory] ******************************************************************************************************************
changed: [monitoring-01]

TASK [loki : Copy loki-local-config.yaml] *********************************************************************************************************
ok: [monitoring-01]

TASK [loki : Copy loki.service] *******************************************************************************************************************
ok: [monitoring-01]

TASK [loki : Start and enable loki] ***************************************************************************************************************
ok: [monitoring-01]

PLAY RECAP ****************************************************************************************************************************************
monitoring-01              : ok=17   changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node1-01                   : ok=9    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
</details>

3. :white_check_mark: Написать Ansible Role для Prometheus-exporter и настроить сбор метрик на работоспособность контейнера с нодой.

<details>
<summary>└─# ansible-playbook playbook.yml</summary>

PLAY [install utils] *************************************************************************************************************************

TASK [docker_install : Install docker packages] **********************************************************************************************
changed: [node-01] => (item=apt-transport-https)
ok: [node-01] => (item=ca-certificates)
ok: [node-01] => (item=curl)
ok: [node-01] => (item=software-properties-common)

TASK [docker_install : Add Docker s official GPG key] ****************************************************************************************
changed: [node-01]

TASK [docker_install : Verify that we have the key with the fingerprint] *********************************************************************
ok: [node-01]

TASK [docker_install : Set up the stable repository] *****************************************************************************************
changed: [node-01]

TASK [docker_install : Update apt packages] **************************************************************************************************
changed: [node-01]

TASK [docker_install : Install docker] *******************************************************************************************************
changed: [node-01]

TASK [docker_install : Add remote "ubuntu" user to "docker" group] ***************************************************************************
changed: [node-01]

TASK [docker_install : Install docker-compose] ***********************************************************************************************
changed: [node-01]

TASK [container_pathfinder : Start container with healthstatus] ******************************************************************************
changed: [node-01]

TASK [prometheus-exporter : Get node-exporter distrib] ***************************************************************************************
changed: [node-01]

TASK [prometheus-exporter : Unarchive a file] ************************************************************************************************
changed: [node-01]

TASK [prometheus-exporter : Run Prometheus] **************************************************************************************************
changed: [node-01]

TASK [promtail : install dependencies] *******************************************************************************************************
changed: [node-01]

TASK [promtail : Get Promtail distrib] *******************************************************************************************************
changed: [node-01]

TASK [promtail : Unarchive a file] ***********************************************************************************************************
changed: [node-01]

TASK [promtail : Copy file] ******************************************************************************************************************
changed: [node-01]

TASK [promtail : Change permissions] *********************************************************************************************************
ok: [node-01]

TASK [promtail : Copy promtail-local-config.yaml] ********************************************************************************************
changed: [node-01]

TASK [promtail : Copy promtail.service] ******************************************************************************************************
changed: [node-01]

TASK [promtail : Start and enable promtail] **************************************************************************************************
changed: [node-01]

PLAY [install monitoring] ********************************************************************************************************************

TASK [grafana : Update package libfontconfig1] ***********************************************************************************************
changed: [monitoring-01]

TASK [grafana : Get Grafana deb] *************************************************************************************************************
changed: [monitoring-01]

TASK [grafana : installed Grafana] ***********************************************************************************************************
changed: [monitoring-01]

TASK [grafana : Make sure grafana service is enabled and running] ****************************************************************************
changed: [monitoring-01]

TASK [prometheus : Get Loki distrib] *********************************************************************************************************
changed: [monitoring-01]

TASK [prometheus : Unarchive a file] *********************************************************************************************************
changed: [monitoring-01]

TASK [prometheus : Copy file] ****************************************************************************************************************
changed: [monitoring-01]

TASK [prometheus : Copy file] ****************************************************************************************************************
changed: [monitoring-01]

TASK [prometheus : Create a directory] *******************************************************************************************************
changed: [monitoring-01]

TASK [prometheus : Copy config.yaml] *********************************************************************************************************
changed: [monitoring-01]

TASK [prometheus : Copy prometheus console_libraries] ****************************************************************************************
changed: [monitoring-01]

TASK [prometheus : Copy prometheus.service] **************************************************************************************************
changed: [monitoring-01]

TASK [prometheus : Start and enable prometheus] **********************************************************************************************
changed: [monitoring-01]

TASK [loki : install dependencies] ***********************************************************************************************************
changed: [monitoring-01]

TASK [loki : Get Loki distrib] ***************************************************************************************************************
changed: [monitoring-01]

TASK [loki : Unarchive a file] ***************************************************************************************************************
changed: [monitoring-01]

TASK [loki : Copy file] **********************************************************************************************************************
changed: [monitoring-01]

TASK [loki : Change permissions] *************************************************************************************************************
ok: [monitoring-01]

TASK [loki : Create a directory] *************************************************************************************************************
changed: [monitoring-01]

TASK [loki : Copy loki-local-config.yaml] ****************************************************************************************************
changed: [monitoring-01]

TASK [loki : Copy loki.service] **************************************************************************************************************
changed: [monitoring-01]

TASK [loki : Start and enable loki] **********************************************************************************************************
changed: [monitoring-01]

PLAY RECAP ***********************************************************************************************************************************
monitoring-01              : ok=22   changed=21    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node-01                    : ok=20   changed=18    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
</details>

4. :white_check_mark: Виртуализировать метрики через Grafana.

![Ссылка 6](https://github.com/Firewal7/crypto-project/blob/main/image/1.6.jpg)

![Ссылка 7](https://github.com/Firewal7/crypto-project/blob/main/image/1.7.jpg)
   
### Hard
1. :white_check_mark: Развернуть несколько нод и систему мониторинга в облаке с помощью Terraform (можно использлвать любое облако на ваш выбор).

![Ссылка 8](https://github.com/Firewal7/crypto-project/blob/main/image/1.8.jpg)

<details>
<summary>└─# terraform apply</summary>

data.yandex_compute_image.ubuntu: Reading...
data.yandex_compute_image.ubuntu: Read complete after 1s [id=fd83vhe8fsr4pe98v6oj]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.platform-monitoring will be created
  + resource "yandex_compute_instance" "platform-monitoring" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "serial-port-enable" = "1"
          + "ssh-keys"           = "ssh-rsa 
        }
      + name                      = "monitoring"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd83vhe8fsr4pe98v6oj"
              + name        = (known after apply)
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options {
          + aws_v1_http_endpoint = (known after apply)
          + aws_v1_http_token    = (known after apply)
          + gce_http_endpoint    = (known after apply)
          + gce_http_token       = (known after apply)
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # yandex_compute_instance.platform-node1 will be created
  + resource "yandex_compute_instance" "platform-node1" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "serial-port-enable" = "1"
          + "ssh-keys"           = "ssh-rsa 
        }
      + name                      = "node1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd83vhe8fsr4pe98v6oj"
              + name        = (known after apply)
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options {
          + aws_v1_http_endpoint = (known after apply)
          + aws_v1_http_token    = (known after apply)
          + gce_http_endpoint    = (known after apply)
          + gce_http_token       = (known after apply)
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # yandex_compute_instance.platform-node2 will be created
  + resource "yandex_compute_instance" "platform-node2" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "serial-port-enable" = "1"
          + "ssh-keys"           = "ssh-rsa 
        }
      + name                      = "node2"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd83vhe8fsr4pe98v6oj"
              + name        = (known after apply)
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + metadata_options {
          + aws_v1_http_endpoint = (known after apply)
          + aws_v1_http_token    = (known after apply)
          + gce_http_endpoint    = (known after apply)
          + gce_http_token       = (known after apply)
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # yandex_vpc_network.develop will be created
  + resource "yandex_vpc_network" "develop" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "develop"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.develop will be created
  + resource "yandex_vpc_subnet" "develop" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "develop"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 5 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + vm_external_ip_address_monitoring = (known after apply)
  + vm_external_ip_address_node1      = (known after apply)
  + vm_external_ip_address_node2      = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_vpc_network.develop: Creating...
yandex_vpc_network.develop: Creation complete after 1s [id=enpu716885jpim90a1tv]
yandex_vpc_subnet.develop: Creating...
yandex_vpc_subnet.develop: Creation complete after 1s [id=e9bripcvupl7it69ruip]
yandex_compute_instance.platform-monitoring: Creating...
yandex_compute_instance.platform-node2: Creating...
yandex_compute_instance.platform-node1: Creating...
yandex_compute_instance.platform-monitoring: Still creating... [10s elapsed]
yandex_compute_instance.platform-node2: Still creating... [10s elapsed]
yandex_compute_instance.platform-node1: Still creating... [10s elapsed]
yandex_compute_instance.platform-monitoring: Still creating... [20s elapsed]
yandex_compute_instance.platform-node2: Still creating... [20s elapsed]
yandex_compute_instance.platform-node1: Still creating... [20s elapsed]
yandex_compute_instance.platform-monitoring: Still creating... [30s elapsed]
yandex_compute_instance.platform-node2: Still creating... [30s elapsed]
yandex_compute_instance.platform-node1: Still creating... [30s elapsed]
yandex_compute_instance.platform-node1: Creation complete after 31s [id=fhmmsk5lomfisu2u91ga]
yandex_compute_instance.platform-monitoring: Still creating... [40s elapsed]
yandex_compute_instance.platform-node2: Still creating... [40s elapsed]
yandex_compute_instance.platform-monitoring: Creation complete after 42s [id=fhms4d8a0rpejpr6hdnj]
yandex_compute_instance.platform-node2: Creation complete after 43s [id=fhm6rtll14vrpe0ag0gj]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

vm_external_ip_address_monitoring = "10.0.1.6"
vm_external_ip_address_node1 = "10.0.1.10"
vm_external_ip_address_node2 = "10.0.1.13"

</details>

2. Настроить систему оповещений при достижении критических событий (заканчивается место на ноде или упал контейнер). Оповещения настроить в телеграмм.
3. Сделать CI/CD-пайплайн для развертывания нод и автоматизировать тестирование ролей в репозитории.
4. Развернуть ноды в облачном Kubernetes на ваш выбор. Предусмотреть автомасштабирование нод в зависимости от потребляемых ими ресурсов.
