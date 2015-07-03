#!/bin/bash
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

# Path to the manage.py command
MANAGE_PY='django-admin.py'

# Prepare the command
export DJANGO_SETTINGS_MODULE=autoslave.settings.single
export PYTHONPATH=/usr/share/autoslave
CMD="${MANAGE_PY}"

TEST=$($CMD check_invoice_pdf)

case "$TEST" in
        OK)  echo "OK: PDF download success | state=1"; exit ${STATE_OK}
        ;;
        *)  echo "CRITICAL: PDF download timeout | state=0"; exit ${STATE_OK}
        ;;
esac
