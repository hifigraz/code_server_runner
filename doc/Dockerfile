FROM python:3.14
EXPOSE 8000
WORKDIR /doc
COPY run.sh /run.sh
RUN pip install --upgrade mkdocs

CMD [ "/run.sh" ]

