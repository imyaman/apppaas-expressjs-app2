var express = require('express');
var path = require('path');
var router = express.Router();
var sysinfo = require(path.join(__dirname, '..', 'lib', 'sysinfo'));

/* Load app metadata from package.json */
var pkg = require(path.join(__dirname, '..', 'package.json'));

/* GET home page. */
router.get('/', function(req, res, next) {
  sysinfo.collectWithPublicIp().then(function (info) {
    res.render('index', {
      title: pkg.name,
      appName: pkg.name,
      version: pkg.version,
      status: 'ok',
      sysinfo: info
    });
  }).catch(function (err) {
    res.render('index', {
      title: pkg.name,
      appName: pkg.name,
      version: pkg.version,
      status: 'ok',
      sysinfo: sysinfo.collect(),
      publicIpError: err && err.message
    });
  });
});

module.exports = router;
