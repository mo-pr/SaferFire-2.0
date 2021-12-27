//region IMPORTS
var methods = require('./methods')
var jwt = require('jsonwebtoken')
var crypto = require('crypto');
var express = require('express');
var expressWs = require('express-ws');
var expressWs = expressWs(express());
var app = expressWs.app;
var wss = expressWs.getWss('/');
//endregion

var prime_length = 60;
var diffHell = crypto.createDiffieHellman(prime_length);
diffHell.generateKeys('base64');

app.ws('/login',(ws,req)=>{
    ws.on('message', msg => {
        var jsonmsg = JSON.parse(msg);
        methods.login(jsonmsg['username'], jsonmsg['password'],diffHell.getPrivateKey(),function (token) {
            ws.send(token)
        });
    })
})

app.ws('/alarm',(ws,req)=>{
    ws.on('message',msg => {
        var jsonmsg = JSON.parse(msg);
        try {
            jwt.verify(jsonmsg['token'], diffHell.getPublicKey(), {algorithm: 'HS256'});
        }catch{
            ws.close()
        }
        methods.alarm(function (alarms) {
            console.log(alarms['cnt_einsaetze'])
            wss.clients.forEach(function broadcast(client) {
                client.send(JSON.stringify(alarms))
            })
        });
    })
})

app.listen(80);