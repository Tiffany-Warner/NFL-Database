module.exports = function(){
    var express = require('express');
    var router = express.Router();
  
    /********************************************************************
     *                      Functions
     *******************************************************************/
    function getTeamTable(res, mysql, context, complete){
        var sql = "SELECT nfl_team.id, nfl_team.name, year_founded, nfl_division.name AS division FROM nfl_team LEFT JOIN nfl_division ON nfl_team.division_id = nfl_division.id";
        mysql.pool.query( sql, function(error, results, fields){
            if(error) throw error;
            context.team = results;
            complete();
        });
    }
    
    function getDivisions(res, mysql, context, complete){
        var sql = "SELECT id, name FROM nfl_division";
        mysql.pool.query(sql, function(error, results, fields){
            if(error) throw error;
            context.division = results;
            complete();
        })
    }
    
    function getTeamStats(res, mysql, context, complete){
        var sql = "SELECT team_id, year, nfl_team.name AS team, wins, losses, ties FROM nfl_team_stats " +
        "INNER JOIN nfl_team " +
        "ON nfl_team.id = nfl_team_stats.team_id "+
        "ORDER BY year, nfl_team.name";
        
        mysql.pool.query( sql, function(error, results, fields){
            if(error) throw error;
            context.team_stats = results;
            complete();
        });
    }
    
   function getTeamForUpdate(res, mysql, context, id, complete){
        var sql = "SELECT id, name, year_founded, division_id FROM nfl_team WHERE nfl_team.id = ?";
        mysql.pool.query( sql, id, function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.teamForUpdate = results[0];
            complete();
        });
    }
    function getTeamStatsForUpdate(res, mysql, context, team, year, complete){
        var sql = "SELECT team_id, nfl_team.name AS name, year, wins, losses, ties FROM nfl_team_stats INNER JOIN nfl_team ON nfl_team.id=nfl_team_stats.team_id WHERE nfl_team_stats.team_id = ? AND nfl_team_stats.year = ?";
        var attributes =[team, year];
        
        mysql.pool.query( sql, attributes, function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            context.teamStatsForUpdate = results[0];
            complete();
        });
    }

    /********************************************************************
     *                      GET Routes
     *******************************************************************/
    router.get("/team", function(req, res){
        var callbackCount = 0;
        var context = {};
        context.jsscripts = ["delete.js"];
        var mysql = req.app.get('mysql');
        getTeamTable(res, mysql, context, complete);
        getDivisions(res, mysql, context, complete);
        getTeamStats(res,mysql, context, complete);
        function complete(){
            callbackCount++;
            if(callbackCount >= 3){
                res.render('team', context);
            }
      }
    });
    
    /********************************************************************
     *                      POST Routes
     *******************************************************************/
    router.post('/team', function(req, res){
        var errorDetails = {};
        var mysql = req.app.get('mysql');
        var sql = "INSERT INTO nfl_team (name, year_founded, division_id) VALUES (?,?,?)";
        var team = [req.body.name, req.body.year, req.body.division];
        mysql.pool.query(sql, team, function(error, results, fields){
            if(error){
                errorDetails.code = error.code;
                errorDetails.number = error.errno;
                errorDetails.msg = error.sqlMessage;
                //Send user to error page
                res.render("error", errorDetails)
            }else{
                res.redirect("/team");
              }
        });
    });
    
    router.post('/team_stats', function(req, res){
        var errorDetails = {};
        var mysql = req.app.get('mysql');
        var sql = "INSERT INTO nfl_team_stats (year, team_id, wins, losses, ties) VALUES (?,?,?,?,?)";
        var team_stats = [req.body.year, req.body.team, req.body.wins, req.body.losses, req.body.ties];
        mysql.pool.query(sql, team_stats, function(error, results, fields){
            if(error){
                errorDetails.code = error.code;
                errorDetails.number = error.errno;
                errorDetails.msg = error.sqlMessage;
                //Send user to error page
                res.render("error", errorDetails)
            }else{
                res.redirect("/team");
              }
        });
    });
    
    /********************************************************************
    *                      Update Routes for Team
    *******************************************************************/
    router.get('/updateTeam', function(req, res, next){
      console.log("Executing updateTeam route to retrieve update page.");
      var context = {};
      var mysql = req.app.get('mysql');
      getTeamForUpdate(res, mysql, context, req.query.id, complete);
      getDivisions(res, mysql, context, complete);
      var callbackCount = 0;
      function complete(){
        callbackCount++;
        if(callbackCount >= 2){
              res.render("updateTeam", context);
        }
      }
    })

    router.post('/updateTeam', function(req,res,next){
        var context = {};
        var mysql = req.app.get('mysql');
        var sql ="UPDATE nfl_team SET name=?, year_founded=?, division_id=? WHERE id=?"
        if(req.body.division == "null" || req.body.division == ""){
            req.body.division = null;
        }
        var attributes = [req.body.name, req.body.year, req.body.division, req.body.id];
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
            getTeamTable(res, mysql, context, complete);
            getDivisions(res, mysql, context, complete);
            getTeamStats(res,mysql, context, complete);
            function complete(){
                callbackCount++;
                if(callbackCount >= 3){
                    res.render('team', context);
                }
            }
          }
        });
    });
    
    /********************************************************************
    *                      Update Routes for Team Stats
    *******************************************************************/
    router.get('/updateTeamStats', function(req, res, next){
      console.log("Executing updateTeamStats route to retrieve update page.");
      var context = {};
      var mysql = req.app.get('mysql');
      console.log(req.query.team, req.query.year);
      getTeamStatsForUpdate(res, mysql, context, req.query.team, req.query.year, complete);
      getTeamTable(res, mysql, context, complete);
      var callbackCount = 0;
      function complete(){
        callbackCount++;
        if(callbackCount >= 2){
              res.render("updateTeamStats", context);
        }
      }
    })

    router.post('/updateTeamStats', function(req,res,next){
        var context = {};
        var mysql = req.app.get('mysql');
        var sql ="UPDATE nfl_team_stats SET wins=?, losses=?, ties=? WHERE team=? AND year=?"
        if(req.body.division == "null" || req.body.division == ""){
            req.body.division = null;
        }
        var attributes = [req.body.name, req.body.year, req.body.division, req.body.id];
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
            getTeamTable(res, mysql, context, complete);
            getDivisions(res, mysql, context, complete);
            getTeamStats(res,mysql, context, complete);
            function complete(){
                callbackCount++;
                if(callbackCount >= 3){
                    res.render('team', context);
                }
            }
          }
        });
    });
    
    
    /********************************************************************
     *                      DELETE Routes
     *******************************************************************/
        router.delete('/team/:id', function(req,res){
            var mysql = req.app.get('mysql');
            var sql = "DELETE FROM nfl_team WHERE id = ?";
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
        
          router.delete('/team/:team_id/:year', function(req,res){
            var mysql = req.app.get('mysql');
            var sql = "DELETE FROM nfl_team_stats WHERE team_id = ? AND year = ?";
            var inserts = [req.params.team_id, req.params.year];
            console.log(req.params.team_id, req.params.year);
            console.log("Executing delete route for Team Stats");
            console.log("Team Stats ID being deleted: " + req.params.id);
            
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