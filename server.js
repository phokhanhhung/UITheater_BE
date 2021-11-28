const express = require('express');
const {sql, conn} = require('./db');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

const PORT = 5000;
app.listen(() => {
  console.log(`server stared on port ${PORT}`);
});
