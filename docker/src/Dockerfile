FROM node:latest
RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/htl-leo-syp-212223-bhif/SaferFire-2.0.git
WORKDIR "/SaferFire-2.0"
RUN git checkout release
WORKDIR "/SaferFire-2.0/web-service"
RUN npm install @nestjs/cli -g
RUN npm install --force
RUN npm run build
EXPOSE 80
CMD ["node","./dist/main.js"]
