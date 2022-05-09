FROM ubuntu:latest
RUN apt-get update && apt-get install -y git
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y npm
RUN git clone https://github.com/htl-leo-syp-212223-bhif/SaferFire-2.0.git
WORKDIR "/SaferFire-2.0"
RUN git checkout release
WORKDIR "/SaferFire-2.0/websocket"
RUN npm install pm2 @nestjs/cli -g
RUN npm install --production
RUN npm run build
EXPOSE 3030