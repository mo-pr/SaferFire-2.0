var XMLHttpRequest = require('xhr2');
const { Client } = require('pg');
var jwt = require('jsonwebtoken')
var crypto = require('crypto');

const client = new Client({
    user: 'dev',
    host: 'IP',
    database: 'saferfire',
    password: 'dev',
    port: 5432,
})
client.connect()

module.exports={
    login: function (uname, passwd, firedep, privateK, _call) {
        var token = undefined;
        client.query("SELECT * from missiondata where LOWER(location) like LOWER('abc')", (err, res) => {
            if (res.rows[0] === undefined) {
                console.log('No user found!')
            }
            else{
                let payload = {
                    username: 'abc',
                    firedep: firedep
                };
                token = jwt.sign(payload, privateK, {expiresIn: "365d", algorithm: 'HS256'})
                console.log(token)
                _call(token)
            }
        })
    },
    register: function(uname,passwd,firedep,email,_call){
        _call();
    },
    alarm: function (_call){
        getJSON('https://cf-intranet.ooelfv.at/webext2/rss/json_2tage.txt',
            function(err, data) {
                if (err !== null) {
                    console.log('Something went wrong: ' + err);
                } else {
                    //console.log(data);
                    _call(data);
                }
        });
    }
};

var getJSON = function(url, callback) {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);
    xhr.responseType = 'json';
    xhr.onload = function() {
        var status = xhr.status;
        if (status === 200) {
            callback(null, xhr.response);
        } else {
            callback(status, xhr.response);
        }
    };
    xhr.send();
};