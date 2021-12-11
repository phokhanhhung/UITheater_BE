const express = require('express');
const {sql, conn} = require('./db');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

const PORT = process.env.PORT || 5000;
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