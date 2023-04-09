#!/bin/sh

sed -i "s/UPDATE_ME/$MONGO_HOST/g" server.js
node server.js
