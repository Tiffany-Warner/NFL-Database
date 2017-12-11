module.exports = function(){
    var express = require('express');
    var router = express.Router();
  
    /********************************************************************
     *                      Functions
     *******************************************************************/
    function getDivisions(res, mysql, context, complete){
        var sql = "SELECT id, name FROM nfl_division";
        mysql.pool.query(sql, function(error, results, fields){
            if(error) throw error;
            context.division = results;
            complete();
        })
    }
    
    function getDivForUpdate(res, mysql, context, id, complete){
        var sql = "SELECT id, name FROM nfl_division WHERE nfl_division.id = ?";
        mysql.pool.query( sql, id, function(error, results, fields){
            if(error){
                res.write(JSON.stringify(error));
                res.end();
            }
            //Returns a list of results, so assign player to the first result
            context.divForUpdate = results[0];
            complete();
        });
    }

    /********************************************************************
     *                      GET Routes
     *******************************************************************/
    router.get("/division", function(req, res){
        var callbackCount = 0;
        var context = {};
        context.jsscripts = ["delete.js"];
        var mysql = req.app.get('mysql');
        getDivisions(res, mysql, context, complete);
        function complete(){
            callbackCount++;
            if(callbackCount >= 1){
                res.render('division', context);
            }
      }
    });
    
    
    /********************************************************************
     *                      POST Routes
     *******************************************************************/
    router.post('/division', function(req, res){
        var errorDetails = {};
        var mysql = req.app.get('mysql');
        var sql = "INSERT INTO nfl_division (name) VALUES (?)";
        var division = [req.body.name];
        
        mysql.pool.query(sql, division, function(error, results, fields){
            if(error){
                errorDetails.code = error.code;
                errorDetails.number = error.errno;
                errorDetails.msg = error.sqlMessage;
                //Send user to error page
                res.render("error", errorDetails);
            }else{
                res.redirect("/division");
              }
        });
    });
    
    /********************************************************************
    *                      Update Routes
    *******************************************************************/
    router.get('/updateDivision', function(req, res, next){
      console.log("Executing updateDivision route to retrieve update page.");
      var context = {};
      var mysql = req.app.get('mysql');
      getDivForUpdate(res, mysql, context, req.query.id, complete);
      var callbackCount = 0;
      function complete(){
        callbackCount++;
        if(callbackCount >= 1){
              res.render("updateDivision", context);
        }
      }
    })

    router.post('/updateDivision', function(req,res,next){
        var context = {};
        var mysql = req.app.get('mysql');
        var sql ="UPDATE nfl_division SET name=? WHERE id=?"
        var attributes = [req.body.name, req.body.id];
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
                getDivisions(res, mysql, context, complete);
                function complete(){
                    callbackCount++;
                    if(callbackCount >= 1){
                        res.render('division', context);
                    }
                };
            };
        });
    });

    /********************************************************************
     *                      DELETE Route
     *******************************************************************/
     router.delete('/division/:id', function(req,res){
        var mysql = req.app.get('mysql');
        var sql = "DELETE FROM nfl_division WHERE id = ?";
        var inserts = [req.params.id];
        console.log("Delete Division route executing");
        console.log("Division ID being deleted: " + req.params.id);
        sql = mysql.pool.query(sql, inserts, function(error, results, fields){
            if(error){
                    errorDetails.code = error.code;
                    errorDetails.number = error.errno;
                    errorDetails.msg = error.sqlMessage;
                    //Send user to error page
                    res.render("error", errorDetails);
            }
            else{
                res.status(202).end();
            }
        });
    })
        
        
    return router;    
}();