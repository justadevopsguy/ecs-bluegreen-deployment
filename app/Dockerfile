FROM 182155805005.dkr.ecr.ap-southeast-1.amazonaws.com/node:18-alpine3.17

ENV APP_USER=app APP_HOME=/home/app

COPY ./ ${APP_HOME}/
COPY package*.json ${APP_HOME}/


RUN adduser -D -u 500 -h ${APP_HOME} -s /bin/false ${APP_USER} \
 && chown -R ${APP_USER}:${APP_USER} ${APP_HOME}

USER ${APP_USER}
WORKDIR ${APP_HOME}

RUN npm install && npm install mongoose-morgan
ENTRYPOINT ["sh", "initsvc.sh"]
