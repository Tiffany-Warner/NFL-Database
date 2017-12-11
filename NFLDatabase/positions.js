module.exports = function(){
    var express = require('express');
    var router = express.Router();
  
    /********************************************************************
     *                      Functions
     *******************************************************************/
    function getPositions(res, mysql, context, complete){
        var sql = "SELECT id, name, type FROM nfl_positions";
        mysql.pool.query( sql, function(error, results, fields){
            if(error) throw error;
            context.positions = results;
            complete();
        });
    }
    function getPlayerPositions(res, mysql, context, complete){
        var sql = "SELECT nfl_position_player.id, nfl_player.fname AS playFname," +
        " nfl_player.Lname AS playLname, player_id, nfl_positions.name AS posName," +
        " position_id, type FROM nfl_position_player" +
        " INNER JOIN nfl_player ON nfl_position_player.player_id = nfl_player.id" +  
        " INNER JOIN nfl_positions ON nfl_position_player.position_id = nfl_positions.id";
        mysql.pool.query( sql, function(error, results, fields){
            if(error) throw error;
            context.player_position = results;
            complete();
        });
    }
    
    function getPlayers(res, mysql, context, complete){
        var q = "SELECT nfl_player.id, fname, lname FROM nfl_player";
        mysql.pool.query( q, function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.players = results;
            complete();
        });
    }
    
    function getPositionForUpdate(res, mysql, context, id, complete){
        var sql = "SELECT id, name, type FROM nfl_positions WHERE nfl_positions.id = ?";
        mysql.pool.query( sql, id, function(error, results, fields){
            if(error) throw error;
            context.posForUpdate = results[0];
            complete();
        });
    }
    
    function getPosPlayForUpdate(res, mysql, context, id, complete){
        var sql =  "SELECT nfl_position_player.id, nfl_player.fname AS playFname," +
        " nfl_player.Lname AS playLname, player_id, nfl_positions.name AS posName," +
        " position_id, type FROM nfl_position_player" +
        " INNER JOIN nfl_player" +
        " ON nfl_position_player.player_id = nfl_player.id" +
        " INNER JOIN nfl_positions ON nfl_position_player.position_id = nfl_positions.id" +
        " WHERE nfl_position_player.id = ?";
        mysql.pool.query( sql, id, function(error, results, fields){
            if(error) throw error;
            context.posPlayForUpdate = results[0];
            complete();
        });
    }

    /********************************************************************
     *                      GET Routes
     *******************************************************************/
    router.get("/positions", function(req, res){
        var callbackCount = 0;
        var context = {};
        context.jsscripts = ["delete.js"];
        var mysql = req.app.get('mysql');
        getPositions(res, mysql, context, complete);
        getPlayerPositions(res, mysql, context, complete);
        getPlayers(res, mysql, context, complete);
        function complete(){
            callbackCount++;
            if(callbackCount >= 3){
                res.render('positions', context);
            }
      }
    });
    
    /********************************************************************
     *                      POST Routes
     *******************************************************************/
    router.post('/positions', function(req, res){
        var errorDetails = {};
        var mysql = req.app.get('mysql');
        var sql = "INSERT INTO nfl_positions (name, type) VALUES (?,?)";

        var positions = [req.body.name, req.body.type];
        console.log(positions);
        
        mysql.pool.query(sql, positions, function(error, results, fields){
            if(error){
                errorDetails.code = error.code;
                errorDetails.number = error.errno;
                errorDetails.msg = error.sqlMessage;
                //Send user to error page
                res.render("error", errorDetails);
            }else{
                res.redirect("/positions");
              }
        });
    });
    
    router.post('/position_player', function(req, res){
        var errorDetails = {};
        var mysql = req.app.get('mysql');
        var sql = "INSERT INTO nfl_position_player (position_id, player_id) VALUES (?,?)";

        var attributes = [req.body.position, req.body.player];
        
        mysql.pool.query(sql, attributes, function(error, results, fields){
            if(error){
                errorDetails.code = error.code;
                errorDetails.number = error.errno;
                errorDetails.msg = error.sqlMessage;
                //Send user to error page
                res.render("error", errorDetails);
            }else{
                res.redirect("/positions#position_player");
              }
        });
    });
    
    /********************************************************************
    *                      Update Routes for Position
    ********************************************************************/
    router.get('/updatePositions', function(req, res, next){
      console.log("Executing updatePosition route to retrieve update page.");
      var context = {};
      var mysql = req.app.get('mysql');
      getPositionForUpdate(res, mysql, context, req.query.id, complete);
      var callbackCount = 0;
      function complete(){
        callbackCount++;
        if(callbackCount >= 1){
              res.render("updatePositions", context);
        }
      }
    })

    router.post('/updatePositions', function(req,res,next){
        var errorDetails = {};
        var context = {};
        var mysql = req.app.get('mysql');
        var sql ="UPDATE nfl_positions SET name=?, type=? WHERE id=?"
        var attributes = [req.body.name, req.body.type, req.body.id];
        mysql.pool.query(sql, attributes, function(error, rows, results){
             if(error){
                    errorDetails.code = error.code;
                    errorDetails.number = error.errno;
                    errorDetails.msg = error.sqlMessage;
                    //Send user to error page
                    res.render("error", errorDetails);
             }
             
             else{
                var callbackCount = 0;
                var context = {};
                context.jsscripts = ["delete.js"];
                var mysql = req.app.get('mysql');
                getPositions(res, mysql, context, complete);
                getPlayerPositions(res, mysql, context, complete);
                getPlayers(res, mysql, context, complete);
                function complete(){
                    callbackCount++;
                    if(callbackCount >= 3){
                        res.render('positions', context);
                    }
                }
             }
        });
    });
    
    router.get('/updatePositionPlayer', function(req, res, next){
      console.log("Executing updatePositionPlayer route to retrieve update page.");
      var context = {};
      var mysql = req.app.get('mysql');
      getPosPlayForUpdate(res, mysql, context, req.query.id, complete);
      getPositions(res, mysql, context, complete)
      var callbackCount = 0;
      function complete(){
        callbackCount++;
        if(callbackCount >= 2){
              res.render("updatePositionPlayer", context);
        }
      }
    });
    
    router.post('/updatePositionPlayer', function(req,res,next){
        var errorDetails = {};
        var context = {};
        var mysql = req.app.get('mysql');
        var sql ="UPDATE nfl_position_player SET position_id = ? WHERE id=?"
        var attributes = [req.body.position, req.body.id];
        mysql.pool.query(sql, attributes, function(error, rows, results){
             if(error){
                    errorDetails.code = error.code;
                    errorDetails.number = error.errno;
                    errorDetails.msg = error.sqlMessage;
                    //Send user to error page
                    res.render("error", errorDetails);
             }
             
             else{
                var callbackCount = 0;
                var context = {};
                context.jsscripts = ["delete.js"];
                var mysql = req.app.get('mysql');
                getPositions(res, mysql, context, complete);
                getPlayerPositions(res, mysql, context, complete);
                getPlayers(res, mysql, context, complete);
                function complete(){
                    callbackCount++;
                    if(callbackCount >= 3){
                        res.render('positions', context);
                    }
                }
             }
        });
    });
    

    /********************************************************************
     *                      DELETE Routes
     *******************************************************************/
     
        router.delete('/positions/:id', function(req,res){
            var mysql = req.app.get('mysql');
            var sql = "DELETE FROM nfl_positions WHERE id = ?";
            var inserts = [req.params.id];
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
        
             
        router.delete('/position_player/:id', function(req,res){
            var mysql = req.app.get('mysql');
            var sql = "DELETE FROM nfl_position_player WHERE id = ?";
            var inserts = [req.params.id];
            console.log("Delete Position_Player route executing");
            console.log("Positions ID being deleted: " + req.params.id);
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