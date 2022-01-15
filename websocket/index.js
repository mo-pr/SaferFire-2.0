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

app.ws('/login',(ws,req)=>{
    ws.on('message', msg => {
        var jsonmsg = JSON.parse(msg);
        methods.login(jsonmsg['username'], jsonmsg['password'], jsonmsg['firedep'],new Buffer( 'ThisStringIsASecret', 'base64' ),function (token) {
            const timeElapsed = Date.now();
            const today = new Date(timeElapsed);
            console.log(today.toISOString() + ": " + jsonmsg['username'] + " logged in")
            ws.send(token)
        });
    })
})

app.ws('/register', (ws,req)=>{
    ws.on('message', msg => {
        var jsonmsg = JSON.parse(msg);
        methods.register(jsonmsg['username'],jsonmsg['password'],jsonmsg['firedep'],jsonmsg['email'],function(){
            const timeElapsed = Date.now();
            const today = new Date(timeElapsed);
            console.log(today.toISOString() + ": " + jsonmsg['username'] + " registered")
            ws.send('USER Registered')
        })
    })
})

app.ws('/alarm',(ws,req)=>{
    ws.on('message',msg => {
        var jsonmsg = JSON.parse(msg);
        jwt.verify(jsonmsg['token'], new Buffer( 'ThisStringIsASecret', 'base64' ),{algorithm:['HS256']},function(err,decode)  {
            if (err) {
                console.log(err)
                ws.send("Invalid Token!");
                ws.close();
            } else {
                methods.alarm(function (alarms) {
                    const timeElapsed = Date.now();
                    const today = new Date(timeElapsed);
                    console.log(today.toISOString() + ": " + jsonmsg['username'] + " requested alarms")
                    wss.clients.forEach(function broadcast(client) {
                        client.send(JSON.stringify(alarms))
                    })
                });
            }
        });
    })
})

app.listen(80);