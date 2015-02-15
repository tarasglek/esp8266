var express = require('express')
var fs = require('fs')
var nodemailer = require("nodemailer");


var app = express()

function sendmail()
{

   var cfg = JSON.parse(fs.readFileSync("config.json").toString());
   var smtpTransport = nodemailer.createTransport("SMTP",cfg.smtp);
   smtpTransport.sendMail(
			  {
			     
                             from: cfg.smtp.auth.user, // sender address
			     to: cfg.to, // comma separated list of receivers
			     subject: "you've got mail",
			     text: "Go check your mail"
			  },
			 function(error, response)
			  {
			     
			        if(error)
			       {
				  
				         console.log(error);
			       }
			     else
			       {
				  
				         console.log("Message sent: " + response.message);
			       }

			  }
			  
			 );

}


app.get('/mail', function (req, res) {
   res.send('OK');
   sendmail();
})

var server = app.listen(80, function () {

  var host = server.address().address
  var port = server.address().port

  console.log('Mail app listening at http://%s:%s/mail', host, port)
})
