var mysql = require('mysql');

var pool = mysql.createPool( { 
    connectionLimit : 10,
    host     : 'localhost',
    user     : 'tiffles',
    database : 'nfl_db'
});

module.exports.pool = pool;
