#!/usr/bin/env sh
cd /doc
[ -z "${PORT}" ] && PORT=8000
BIND=0.0.0.0:${PORT}
echo Starting mkdocs on BIND ${BIND}
mkdocs serve -a ${BIND}
