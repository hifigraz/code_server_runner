FROM python:3.12
WORKDIR /workspace_ro
COPY workspace /workspace
COPY run.sh /run.sh

RUN pip install --upgrade sqlalchemy fastapi[standard] psycopg2

CMD [ "/run.sh" ]
