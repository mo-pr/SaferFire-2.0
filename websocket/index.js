//region IMPORTS
var methods = require('./methods')
var express = require('express');
var expressWs = require('express-ws');
var expressWs = expressWs(express());
var app = expressWs.app;
var wss = expressWs.getWss('/');
//endregion

app.ws('/login',(ws,req)=>{
    ws.on('message', msg => {
        console.log(msg);
        var jsonmsg = JSON.parse(msg);
        ws.send(methods.login(jsonmsg['username'], jsonmsg['password']));
    })
})

app.ws('/alarm',(ws,req)=>{
    ws.on('message',msg=>{
        var jsonmsg = JSON.parse(msg);
        console.log(methods.alarm(jsonmsg['firedep']));
        wss.clients.forEach(function broadcast(client){
            client.send('Alarm '+msg);
        })
    })
})

app.listen(80);