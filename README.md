# Домашнее задание к занятию 3 «Использование Ansible»

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.
Решение 1. При помощи terraform запускается три ВМ с приватными и публичными адресами, после данные из output переносятся в inventory/prod.yml
3. Репозиторий LightHouse находится [по ссылке](https://github.com/VKCOM/lighthouse).

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.

Решение 1. Playbook был дописан - [site.yml](https://github.com/pythonyandex/Ansible_L3/blob/main/playbook/site.yml)
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.

Решение 3. Конфиги залиты в [template](https://github.com/pythonyandex/Ansible_L3/tree/main/playbook/templates), очень много их менял, но до конца разобраться с работой vector/clickhouse пока не получилось, надо смотреть видео.
4. Подготовьте свой inventory-файл `prod.yml`.

Решение 4. [prod.yml](https://github.com/pythonyandex/Ansible_L3/blob/main/playbook/inventory/prod.yml) заполняется в соотвествии с terraform output.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
