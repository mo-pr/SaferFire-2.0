FROM keymetrics/pm2:latest-stretch
RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/htl-leo-syp-212223-bhif/SaferFire-2.0.git
WORKDIR "/SaferFire-2.0"
RUN git checkout release
WORKDIR "/SaferFire-2.0/websocket"
RUN npm install @nestjs/cli -g
RUN npm install --production
RUN npm run build
ENV PM2_PUBLIC_KEY a7cmhleidxmzbe6
ENV PM2_SECRET_KEY 7l9ala1vopm5184
EXPOSE 3030
RUN pm2 startup
RUN pm2 save
CMD ["pm2", "start","./dist/main.js"]