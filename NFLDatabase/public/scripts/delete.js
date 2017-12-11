//Reference the lecture video https://media.oregonstate.edu/media/t/0_mfkbsz2u
function deletePlayer(id){
    $.ajax({
        url: '/player/' + id,
        type: 'DELETE',
        success: function(result){
            window.location.reload(true);
        }
    })
};

function deleteTeam(id){
    console.log("Executing deleteTeam clientside with id: " + id)
    $.ajax({
        url: '/team/' + id,
        type: 'DELETE',
        success: function(result){
            window.location.reload(true);
        }
    })

};

function deleteTeamStats(team_id, year){
    $.ajax({
        url: '/team/' + team_id + '/'+ year,
        type: 'DELETE',
        success: function(result){
            window.location.reload(true);
        }
    })

};

function deleteDivision(id){
    $.ajax({
        url: '/division/' + id,
        type: 'DELETE',
        success: function(result){
            window.location.reload(true);
        }
    })

};

function deletePosition(id){
    $.ajax({
        url: '/positions/' + id,
        type: 'DELETE',
        success: function(result){
            window.location.reload(true);
        }
    })

};

function deletePositionPlayer(id){
    $.ajax({
        url: '/position_player/' + id,
        type: 'DELETE',
        success: function(result){
            window.location.reload(true);
        }
    })

};