module.exports = function(){
    var express = require('express');
    var router = express.Router();

    /********************************************************************
     *                      Functions
     *******************************************************************/
    function getPlayerTeamPosForSearch(){
        var q = "SELECT fname, lname, IFNULL(nfl_team.name, 'No Team') AS teamName, IFNULL(nfl_positions.name, 'No position') AS position FROM nfl_player LEFT JOIN nfl_team ON nfl_player.team_id = nfl_team.id LEFT JOIN nfl_position_player ON nfl_player.id = nfl_position_player.player_id LEFT JOIN nfl_positions ON nfl_position_player.position_id = nfl_positions.id WHERE fname LIKE '?%' AND lname LIKE '?%'"
        return q;
    }
    
    function getPlayerTeamForSearch(){
        var q = "SELECT fname, lname, IFNULL(nfl_team.name, 'No Team') AS teamName FROM nfl_player" + 
        " LEFT JOIN nfl_team" + 
        "   ON nfl_player.team_id = nfl_team.id" +
        " WHERE fname LIKE '?%' AND lname LIKE '?%'";
        return q;
    }
    
    function getPlayerPosForSearch(){
        var q = "SELECT fname, lname, IFNULL(nfl_positions.name, 'No position') AS position FROM nfl_player" + 
        " LEFT JOIN nfl_position_player" + 
        "   ON nfl_player.id = nfl_position_player.player_id" +
        " LEFT JOIN nfl_positions" +
        "   ON nfl_position_player.position_id = nfl_positions.id" +
        " WHERE fname LIKE '?%' AND lname LIKE '?%'";
        return q;
    }

    /********************************************************************
     *                      GET Routes
     *******************************************************************/ 
    // router.get('/searchPlayer', function(req, res, next){
    //   console.log("Executing searchPlayer route to retrieve results.");
    //   var context = {};
    //   var errorDetails = {};
    //   var mysql = req.app.get('mysql');
    //   var playerName = [req.query.fname, req.query.lname];
      
    //   console.log(req.query.fname, req.query.lname, req.query.findTeam, req.query.findPos);
      
    //   if(req.query.lname === undefined){
    //       req.query.lname =="";
    //   }
      
    //   //Search for player, team, and position
    //   if(req.query.findTeam === "true" && req.query.findPos ==="true"){
    //     var q = getPlayerTeamPosForSearch();
    //     mysql.pool.query( q, playerName, function(error, results, fields){
    //         if(error){
    //             errorDetails.code = error.code;
    //             errorDetails.number = error.errno;
    //             errorDetails.msg = error.sqlMessage;
    //             //Send user to error page
    //             res.render("error", errorDetails);
    //         }
    //         context.playerTeamPosForSearch = results;
    //         console.log(results);
    //         context.teamPos = true;
    //         var callbackCount = 0;
    //         function complete(){
    //             callbackCount++;
    //             if(callbackCount >= 1){
    //                 res.render("searchPlayer", context);
    //             }
    //         }
    //     });
    //   }
    //   //Search for player and team
    //   else if(req.query.Team ==="true" && req.query.findPos == undefined){
    //     var q = getPlayerTeamForSearch();
    //     mysql.pool.query( q, playerName, function(error, results, fields){
    //         if(error){
    //             errorDetails.code = error.code;
    //             errorDetails.number = error.errno;
    //             errorDetails.msg = error.sqlMessage;
    //             //Send user to error page
    //             res.render("error", errorDetails);
    //         }
    //         context.playerTeamForSearch = results;
    //         console.log(results);
    //         context.teamPos = true;
    //         var callbackCount = 0;
    //         function complete(){
    //             callbackCount++;
    //             if(callbackCount >= 1){
    //                 res.render("searchPlayer", context);
    //             }
    //         }
    //     });
    //   }
    //   //Search for player and position
    //   else if(req.query.Team === undefined && req.query.findPos == "true"){
    //   var q =  getPlayerPosForSearch();
    //     mysql.pool.query( q, playerName, function(error, results, fields){
    //         if(error){
    //             errorDetails.code = error.code;
    //             errorDetails.number = error.errno;
    //             errorDetails.msg = error.sqlMessage;
    //             //Send user to error page
    //             res.render("error", errorDetails);
    //         }
    //         context.playerPosForSearch = results;
    //         console.log(results);
    //         context.teamPos = true;
    //         var callbackCount = 0;
    //         function complete(){
    //             callbackCount++;
    //             if(callbackCount >= 1){
    //                 res.render("searchPlayer", context);
    //             }
    //         }
    //      });
    //     }
    //     //Only player is being searched for. 
    //   else{
    //     var q = getPlayerForSearch();
    //     mysql.pool.query( q, playerName, function(error, results, fields){
    //         if(error){
    //             errorDetails.code = error.code;
    //             errorDetails.number = error.errno;
    //             errorDetails.msg = error.sqlMessage;
    //             //Send user to error page
    //             res.render("error", errorDetails);
    //         }
    //         context.playerForSearch = results;
    //         console.log(results);
    //         context.teamPos = true;
    //         var callbackCount = 0;
    //         function complete(){
    //             callbackCount++;
    //             if(callbackCount >= 1){
    //                 res.render("searchPlayer", context);
    //             }
    //         }
    //     });
    //   }
    // });


   function getPlayerForSearch(res, mysql, context, id, complete){
        var errorDetails = {};
        var sql = "SELECT fname, lname FROM nfl_player WHERE id = ?";
        mysql.pool.query( sql, id, function(error, results, fields){
            if(error){
                errorDetails.code = error.code;
                errorDetails.number = error.errno;
                errorDetails.msg = error.sqlMessage;
                //Send user to error page
                res.render("error", errorDetails);
            }
            context.playerForSearch = results;
            console.log(results);
            context.player = true;
            complete();
        });
    }
    
   function getPlayerTeamForSearch(res, mysql, context, id, complete){
        var errorDetails = {};
        var sql = "SELECT fname, lname, IFNULL(nfl_team.name, 'No Team') AS teamName FROM nfl_player" + 
        " LEFT JOIN nfl_team" + 
        "   ON nfl_player.team_id = nfl_team.id" +
        " WHERE nfl_player.id = ?";
        mysql.pool.query( sql, id, function(error, results, fields){
            if(error){
                errorDetails.code = error.code;
                errorDetails.number = error.errno;
                errorDetails.msg = error.sqlMessage;
                //Send user to error page
                res.render("error", errorDetails);
            }
            context.playerTeamForSearch = results;
            console.log(results);
            context.playerTeam = true;
            complete();
        });
    }
     
     function getPlayerPosForSearch(res, mysql, context, id, complete){
        var errorDetails = {};
        var sql = "SELECT fname, lname, IFNULL(nfl_positions.name, 'No position') AS position FROM nfl_player" + 
        " LEFT JOIN nfl_position_player" + 
        "   ON nfl_player.id = nfl_position_player.player_id" +
        " LEFT JOIN nfl_positions" +
        "   ON nfl_position_player.position_id = nfl_positions.id" +
        " WHERE nfl_player.id = ?";
        mysql.pool.query( sql, id, function(error, results, fields){
            if(error){
                errorDetails.code = error.code;
                errorDetails.number = error.errno;
                errorDetails.msg = error.sqlMessage;
                //Send user to error page
                res.render("error", errorDetails);
            }
            context.playerPosForSearch = results;
            console.log(results);
            context.playerPos = true;
            complete();
        });
    }
    
    function getPlayerTeamPosForSearch(res, mysql, context, id, complete){
        var errorDetails = {};
        var sql = "SELECT fname, lname, IFNULL(nfl_team.name, 'No Team') AS teamName," +
        " IFNULL(nfl_positions.name, 'No position') AS position FROM nfl_player" +
        " LEFT JOIN nfl_team" +
        " ON nfl_player.team_id = nfl_team.id" +
        " LEFT JOIN nfl_position_player" +
        " ON nfl_player.id = nfl_position_player.player_id" +
        " LEFT JOIN nfl_positions" +
        " ON nfl_position_player.position_id = nfl_positions.id" +
        " WHERE nfl_player.id = ?"
        mysql.pool.query( sql, id, function(error, results, fields){
            if(error){
                errorDetails.code = error.code;
                errorDetails.number = error.errno;
                errorDetails.msg = error.sqlMessage;
                //Send user to error page
                res.render("error", errorDetails);
            }
            context.playerTeamPosForSearch = results;
            console.log(results);
            context.playerTeamPos = true;
            complete();
        });
    }



    router.get('/searchPlayer', function(req, res, next){
      console.log("Executing searchPlayer route to retrieve results.");
     var callbackCount = 0;
      var context = {};
      var mysql = req.app.get('mysql');
      if(req.query.findTeam == undefined && req.query.findPos == undefined){
            getPlayerForSearch(res, mysql, context, req.query.id, complete);
      }
      else if(req.query.findTeam === "true" && req.query.findPos == undefined){
           getPlayerTeamForSearch(res, mysql, context, req.query.id, complete);
      }
     else if(req.query.findTeam == undefined && req.query.findPos === "true"){
           getPlayerPosForSearch(res, mysql, context, req.query.id, complete);
      }
      else{
          getPlayerTeamPosForSearch(res, mysql, context, req.query.id, complete);
      }
      console.log(req.query.id);
        function complete(){
            callbackCount++;
            if(callbackCount >= 1){
                res.render("searchPlayer", context);
            }
        }
            
    });
   
    return router;    
}();
 