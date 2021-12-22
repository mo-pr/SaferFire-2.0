var XMLHttpRequest = require('xhr2');

module.exports={
    login: function (username, passwd){
        return username+"\n"+passwd;
    },
    alarm: function (firedep){
        const Http = new XMLHttpRequest();
        const url='https://cf-intranet.ooelfv.at/webext2/rss/json_2tage.txt';
        Http.open("GET", url);
        Http.send();
        Http.onreadystatechange = (e) => {
            console.log(Http.responseText)
        }
        return 'ALARM '+firedep;
    }
};
