const sql = require('mssql/msnodesqlv8');

const config = {
  user: 'sa',
  password: '123456',
  database: 'QLDV',
  server: 'localhost\\TUANLESERVER',
}

var conn = new sql.ConnectionPool(config).connect().then(pool => {
  return pool;
});

module.exports = {
  sql, 
  conn,
}

