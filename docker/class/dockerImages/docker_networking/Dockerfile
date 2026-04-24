FROM     python:3.12-alpine
WORKDIR    /app
COPY    app_old.py    .
RUN    pip    install     mysql-connector-python
CMD    ["python", "app_old.py"]
