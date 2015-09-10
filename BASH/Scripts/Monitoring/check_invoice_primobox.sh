#!/bin/bash
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

# Path to the manage.py command
MANAGE_PY='django-admin.py'

# Prepare the command
export http_proxy=http://proxy.infra.autolib.eu:8080/
export ftp_proxy=http://proxy.infra.autolib.eu:8080/
export https_proxy=http://proxy.infra.autolib.eu:8080/
export DJANGO_SETTINGS_MODULE=autoslave.settings.single
export PYTHONPATH=/usr/share/autoslave
CMD="${MANAGE_PY}"

TEST=$(/usr/bin/django-admin.py check_invoice_pdf)
TIME=$(/usr/bin/django-admin.py check_invoice_pdf | grep -Eo '.\...')

TIMEINT=$(echo $TIME | sed s/"\."//g)

if [[ $TIMEINT -ge 400 ]]; then
    echo "CRITICAL: PDF download took $TIME seconds | time_in_sec="$TIME""; exit ${STATE_CRITICAL}
fi

case "$TEST" in
        OK*)  echo "OK: PDF download success | time_in_sec="$TIME""; exit ${STATE_OK}
        ;;
        *)  echo "CRITICAL: PDF download timeout | time_in_sec="$TIME""; exit ${STATE_OK}
        ;;
esac