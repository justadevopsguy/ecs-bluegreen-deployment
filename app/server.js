const os = require('os');
const process = require('process');
const express = require('express');
const mongooseMorgan = require('mongoose-morgan');

const app = express();

const port = process.env.port || 8080;
const usedMemory = process.memoryUsage().heapUsed / 1024 / 1024;

// timestamp
const ts = Date.now();
const date_ob = new Date(ts);
const date = date_ob.getDate();
const month = date_ob.getMonth() + 1;
const year = date_ob.getFullYear();

// cpu usage
const startTime = process.hrtime();
const startUsage = process.cpuUsage();

while (Date.now() - ts < 500);

const elapTime = process.hrtime(startTime)
const elapUsage = process.cpuUsage(startUsage)
const elapTimeMS = secNSec2ms(elapTime)
const elapUserMS = secNSec2ms(elapUsage.user)
const elapSystMS = secNSec2ms(elapUsage.system)
const cpuPercent = Math.round(100 * (elapUserMS + elapSystMS) / elapTimeMS)


function secNSec2ms(secNSec) {
  if (Array.isArray(secNSec)) {
    return secNSec[0] * 1000 + secNSec[1] / 1000000;
  }
  return secNSec / 1000;
}

app.use(mongooseMorgan({
  collection: 'access_logger',
  connectionString: 'mongodb+srv://UPDATE_ME/?retryWrites=true&w=majority',
},
  {
    skip: function (req, res) {
      return res.statusCode < 200;

    }
  },
  'dev'
));


app.get('/', (req, res) => {
  const osResponse = `The OS Type is ${os.type()} with release ${os.release()} using platform ${os.platform()}`;

  res.send(osResponse + '<br>' + trialResponse);
});

app.listen(port);
console.log('Hello ' + process.env.NAME)
console.log('Server running on port... ' + port);