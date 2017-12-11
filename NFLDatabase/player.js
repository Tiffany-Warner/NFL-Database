module.exports = function(){
    var express = require('express');
    var router = express.Router();
  
    /********************************************************************
     *                      Functions
     *******************************************************************/
    function getTeams(res, mysql, context, complete){
        var sql = "SELECT id, name FROM nfl_team";
        mysql.pool.query( sql, function(error, results, fields){
            if(error) throw error;
            context.teams = results;
            complete();
        });
    }
    
    function getPlayers(res, mysql, context, complete){
        var q = "SELECT nfl_player.id, fname, lname, nfl_team.name AS team, DATE_FORMAT(dob, '%m/%d/%Y') AS dob, year_drafted, title FROM nfl_player LEFT JOIN nfl_team ON nfl_player.team_id = nfl_team.id";
        mysql.pool.query( q, function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.players = results;
            complete();
        });
    }
    
        /********************************************************
         *                  Update Function                     *
         * Description: Prepopulate input fields for update page*
         *******************************************************/
        function getPlayerForUpdate(res, mysql, context, id, complete){
        var sql = "SELECT nfl_player.id, fname, lname, DATE_FORMAT(dob, '%Y-%m-%d') AS dob, year_drafted, title, team_id FROM nfl_player WHERE nfl_player.id = ?";
        var playerId = id;
        mysql.pool.query( sql, playerId, function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            //Returns a list of results, so assign player to the first result
            context.playerForUpdate = results[0];
            complete();
        });
    }
    

    /********************************************************************
     *                      GET Routes
     *******************************************************************/
    router.get("/player", function(req, res){
        var callbackCount = 0;
        var context = {};
        context.jsscripts = ["delete.js"];
        var mysql = req.app.get('mysql');
        getTeams(res, mysql, context, complete);
        getPlayers(res, mysql, context, complete);
        function complete(){
            callbackCount++;
            if(callbackCount >= 2){
                res.render('player', context);
            }
      }
    });
    
  
    /********************************************************************
    *                      Update Routes
    *******************************************************************/
    router.get('/updatePlayer', function(req, res, next){
      console.log("Executing updatePlayer route to retrieve update page.");
      var context = {};
      var mysql = req.app.get('mysql');
      getPlayerForUpdate(res, mysql, context, req.query.id, complete);
      getTeams(res, mysql, context, complete);
      var callbackCount = 0;
      function complete(){
        callbackCount++;
        if(callbackCount >= 2){
              res.render("updatePlayer", context);
        }
      }
    })

    router.post('/updatePlayer', function(req,res,next){
        console.log("Editing");
        var context = {};
        var mysql = req.app.get('mysql');
        var sql ="UPDATE nfl_player SET fname=?, lname=?, team_id= ?, dob=?, year_drafted=?, title=? WHERE id=?"
        if(req.body.team == "null" || req.body.team == ""){
            req.body.team = null;
        }
        console.log(req.body.fname, req.body.lname, req.body.team, req.body.dob, req.body.year_drafted, req.body.title, req.body.id);
        
        var attributes = [req.body.fname, req.body.lname, req.body.team, req.body.dob, req.body.year_drafted, req.body.title, req.body.id];
        
        mysql.pool.query(sql, attributes, function(error, rows, results){
         if(error){
             res.write(JSON.stringify(error)); 
             res.end();
         }
          else{
            var callbackCount = 0;
            var context = {};
            context.jsscripts = ["delete.js"];
            var mysql = req.app.get('mysql');
            getTeams(res, mysql, context, complete);
            getPlayers(res, mysql, context, complete);
            function complete(){
                callbackCount++;
                if(callbackCount >= 2){
                    res.render('player', context);
                }
            }
          }
        });
    });
    /********************************************************************
     *                      INSERT Route
     *******************************************************************/
    router.post('/player', function(req, res){
        var errorDetails = {};
        var mysql = req.app.get('mysql');
        var sql = "INSERT INTO nfl_player (fname, lname, team_id, dob, year_drafted, title) VALUES (?,?,?,?,?,?)";
        //DOB: YYYYMMDD
        var dob = req.body.year + '-' + req.body.month + '-' + req.body.day;
        
        var player = [req.body.fname, req.body.lname, req.body.team, dob, req.body.year_drafted, req.body.title ];
        console.log(player);
        
        mysql.pool.query(sql, player, function(error, results, fields){
            if(error){
                errorDetails.code = error.code;
                errorDetails.number = error.errno;
                errorDetails.msg = error.sqlMessage;
                //Send user to error page
                res.render("error", errorDetails);
            }else{
                res.redirect("/player");
              }
        });
    });

    /********************************************************************
     *                      DELETE Route
     *******************************************************************/
        router.delete('/player/:id', function(req,res){
            var mysql = req.app.get('mysql');
            var sql = "DELETE FROM nfl_player WHERE id = ?";
            var inserts = [req.params.id];
            console.log("Delete Player route executing");
            console.log("Player ID being deleted: " + req.params.id);
            sql = mysql.pool.query(sql, inserts, function(error, results, fields){
                if(error){
                    res.write(JSON.stringify(error));
                    res.status(400);
                    res.end();
                }
                else{
                    res.status(202).end();
                }
            })
        })
        
    return router;    
}();