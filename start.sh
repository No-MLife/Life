#!/bin/bash

# Start the backend
java -jar -Duser.timezone=Asia/Seoul /app/app.jar &

# Start nginx
nginx -g "daemon off;"
