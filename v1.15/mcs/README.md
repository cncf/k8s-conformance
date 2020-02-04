## To Reproduce:

Note: to reproduce you need a Mail.Ru Cloud Solutions account. You can create it by signing up at https://mcs.mail.ru/app/en/signup/ 

### Create cluster

Login to Mail.Ru Cloud Solutions and activate your account at https://mcs.mail.ru/app/en/

Then follow the instructions to create a single cluster (only in Russian for now):

Выберите сервис «Контейнеры» и перейдите в «Кластеры Kubernetes».

Нажмите «Добавить». Откроется страница с настройками кластера.

Заполните форму.

Выберите, автомасштабировать ли кластер (в случае периодически возникающих высоких нагрузок это будет полезным)

Нажмите «Создать кластер».

Создание кластера займет от 5 до 20 минут. После этого откроется страница с его характеристиками и инструкцией по подключению. 

Также на ваш компьютер будет предложено скачать файл настроек кластера с расширением *.YML - (например, kubernetes-cluster-8643_kubeconfig.yml).

### Get Credentials

Open up the firewall from your IP to the cluster for kubectl:

Head to Network Settings, add a new rule and enter your IP address (from), Kubernetes servers (to) and TCP (protocol) 6443 (port).

Go to https://mcs.mail.ru/app/en/services/containers/list/ then select your cluster and download kubeconfig archive.

After you unpack the archive, set KUBECONFIG env variable and check access to your cluster:

```bash
export KUBECONFIG=~/Downloads/<cluster_name>/config
kubectl get nodes
```

### Run the tests

You can use the Sonobuoy to run the tests:

https://sonobuoy.io/

