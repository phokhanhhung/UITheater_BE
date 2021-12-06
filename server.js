'use strict';
var express = require('express');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var ejs = require('ejs');
var engine = require('ejs-mate');
var session = require('express-session');
var mongoose = require('mongoose');
var MongoStore = require('connect-mongo')(session);
var passport = require('passport');
var flash = require('connect-flash');

var app = express();

mongoose.connect('mongodb://localhost/baith1')

require('./config/passport');

app.use(express.static('public'));

app.engine('ejs', engine);
app.set('view engine', 'ejs');
app.use(cookieParser());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use(session({
  secret: 'Thisismytestkey',
  resave: false,
  saveUninitialized: false,
  store: new MongoStore({mongooseConnection: mongoose.connection})
}));

app.use(flash());
app.use(passport.initialize());
app.use(passport.session());

require('./routes/user')(app, passport);

// app.listen('3000', function () {
//   console.log('Listening on port 3000!');
// });

const PORT = 5000;
app.listen(PORT, () => {
  console.log(`server stared on port ${PORT}`);
});

app.get('/phim', async(req, res) => {
  var pool = await conn;
  var sqlString = "select TENPHIM, DOTUOI, MOTA, THELOAI " + 
                  "from PHIM P join PHIM_THELOAI PTL on P.MAPHIM = PTL.MAPHIM " + 
                  "join THELOAI TL on TL.MATL = PTL.MATL"
  return await pool.request()
  .query(sqlString)
  .then(data => {
    if(data.recordset.length >= 1) {
      res.send(data.recordset);
    } else res.send('0');
  })
  .catch(err => res.send('0'));
})

app.get('/phim/:phim', async(req, res) => {
  var pool = await conn;
  var name = req.params.phim.slice(1);
  var sqlString = `select * from PHIM join PHIM_THELOAI 
                  on PHIM.MAPHIM = PHIM_THELOAI.MAPHIM 
                  join THELOAI on THELOAI.MATL = PHIM_THELOAI.MATL 
                  where TENPHIM like N'%${name}%'`;
  return await pool.request()
  .query(sqlString)
  .then(data => {
    res.send(data);
    console.log(data);
  })
  .catch(err => {
    res.send(err);
    console.log(err);
  })
});
