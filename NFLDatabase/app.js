
//Add express
var express = require("express");
var app = express();

//Add express-handlebars
var handlebars = require('express-handlebars');

//Add bodyParser
var bodyParser = require('body-parser');

app.use(bodyParser.urlencoded({extended: false}));
app.use(bodyParser.json());

app.use(express.static(__dirname + "/public"));

var mysql = require('./public/scripts/dbcon.js');

//Reference https://stackoverflow.com/questions/16385173/node-js-express-handlebars-js-partial-views
app.engine('handlebars', handlebars({
  extname: 'handlebars',
  defaultLayout: 'main',
  layoutsDir: __dirname + '/views/layouts/',
  partialsDir: __dirname + '/views/partials/'
}));

app.set('view engine', 'handlebars');

app.set('mysql', mysql);

//Set the port number
app.set('port', (process.env.PORT));

//Use player.js
app.use('/', require('./player.js'));

//Use team.js
app.use('/', require('./team.js'));

//Use division.js
app.use('/', require('./division.js'));

//Use position.js
app.use('/', require('./positions.js'));

//Use search.js
app.use('/', require('./search.js'));

/********************************************************************
*                      Functions
*******************************************************************/
function getDivisionsTable(res, mysql, context, complete){
    var sql ="SELECT name FROM nfl_division";
    mysql.pool.query( sql, function(error, results, fields){
        if(error) throw error;
        context.divisions = results;
        complete();
    });
}

function getTeamStatsTable(res, mysql, context, complete){
    var sql = "SELECT year, nfl_team.name AS name, wins, losses, ties FROM nfl_team_stats INNER JOIN nfl_team ON nfl_team_stats.team_id = nfl_team.id ORDER BY year";
    mysql.pool.query( sql, function(error, results, fields){
        if(error) throw error;
        context.team_stats = results;
        complete();
    });
}

function getTeamTable(res, mysql, context, complete){
    var sql = "SELECT nfl_team.name, year_founded, nfl_division.name AS division FROM nfl_team INNER JOIN nfl_division ON nfl_team.division_id = nfl_division.id";
    mysql.pool.query( sql, function(error, results, fields){
        if(error) throw error;
        context.team = results;
        complete();
    });
}

function getPlayerTeams(res, mysql, context, complete){
    var sql = "SELECT id, name AS playerTeam FROM nfl_team";
    mysql.pool.query( sql, function(error, results, fields){
        if(error) throw error;
        context.playerTeam = results;
        complete();
    });
}

function getPlayers(res, mysql, context, complete){
    var sql = "SELECT nfl_player.id, fname, lname, nfl_team.name AS playerTeam, DATE_FORMAT(dob, '%m/%d/%Y') AS dob, year_drafted, title FROM nfl_player INNER JOIN nfl_team ON nfl_player.team_id = nfl_team.id";
    mysql.pool.query( sql, function(error, results, fields){
        if(error){
            res.write(JSON.stringify(error));
            res.end();
        }
        context.players = results;
        complete();
    });
}
function getPositions(res, mysql, context, complete){
    var sql = "SELECT id, name, type FROM nfl_positions";
    mysql.pool.query( sql, function(error, results, fields){
        if(error) throw error;
        context.positions = results;
        complete();
    });
}
function getPlayerPositions(res, mysql, context, complete){
    var sql = "SELECT nfl_player.fname AS playFname, nfl_player.Lname AS playLname, player_id, nfl_positions.name AS posName, position_id, type FROM nfl_position_player INNER JOIN nfl_player ON nfl_position_player.player_id = nfl_player.id  INNER JOIN nfl_positions ON nfl_position_player.position_id = nfl_positions.id";
    mysql.pool.query( sql, function(error, results, fields){
        if(error) throw error;
        context.player_position = results;
        complete();
    });
}
/********************************************************************
*                      GET Routes
*******************************************************************/
app.get("/", function(req, res){
    var callbackCount = 0;
    var context = {};
    getPlayerTeams(res, mysql, context, complete);
    getPlayers(res,mysql,context, complete);
    getTeamTable(res,mysql,context, complete);
    getTeamStatsTable(res, mysql, context, complete);
    getDivisionsTable(res, mysql, context, complete);
    getPositions(res,mysql,context,complete);
    getPlayerPositions(res, mysql, context, complete);
    function complete(){
        callbackCount++;
        if(callbackCount >= 7){
          res.render('home', context);
        }
    }
  
});

app.get("/position", function(req, res){
    res.render('position');
});


/********************************************************************
*                      POST Routes
*******************************************************************/


/********************************************************************
 *                      404 Error Handler
 *******************************************************************/
app.use(function(req,res){
  res.status(404);
  res.render('404');
});

/********************************************************************
 *                      500 Error Handler
 *******************************************************************/
app.use(function(err, req, res, next){
  console.error(err.stack);
  res.type('plain/text');
  res.status(500);
  res.render('500');
});


app.listen(app.get("port"), process.env.IP, function(){
    console.log("Server has started! Listening on port: " + process.env.PORT);
});