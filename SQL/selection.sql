-- =====================================================================================
--                          SELECT for Display Queries
-- =====================================================================================
-- Get division names
SELECT name FROM nfl_division;

-- Get specific dvision
SELECT id, name FROM nfl_division WHERE nfl_division.id = [divisionId];

-- Get Team Stats ordered by Year
SELECT year, nfl_team.name AS name, wins, losses, ties FROM nfl_team_stats 
INNER JOIN nfl_team 
    ON nfl_team_stats.team_id = nfl_team.id ORDER BY year;
    
-- Get a specific stat for a team and year    
SELECT team_id, nfl_team.name AS name, year, wins, losses, ties FROM nfl_team_stats 
INNER JOIN nfl_team 
    ON nfl_team.id=nfl_team_stats.team_id 
WHERE nfl_team_stats.team_id = [team] AND nfl_team_stats.year = [year];
            

--  Get Teams and their divisons
SELECT nfl_team.name, year_founded, nfl_division.name AS division FROM nfl_team 
INNER JOIN nfl_division 
    ON nfl_team.division_id = nfl_division.id;
    
-- Get ids and names of team
SELECT id, name AS playerTeam FROM nfl_team;

-- Get a specific team
SELECT id, name, year_founded, division_id FROM nfl_team WHERE nfl_team.id = [teamId];

-- Get players and their teams
SELECT nfl_player.id, fname, lname, nfl_team.name AS playerTeam, 
    DATE_FORMAT(dob, '%m/%d/%Y') AS dob, year_drafted, title FROM nfl_player 
INNER JOIN nfl_team 
    ON nfl_player.team_id = nfl_team.id;
    
-- Get specific player and team
SELECT nfl_player.id, fname, lname, DATE_FORMAT(dob, '%Y-%m-%d') AS dob, year_drafted, title, team_id FROM nfl_player WHERE nfl_player.id = [playerId];

-- Get position id, names and types
SELECT id, name, type FROM nfl_positions;

-- Get a specific position
SELECT id, name, type FROM nfl_positions WHERE nfl_positions.id = [positionId];
    
-- Get Players' Positions
SELECT nfl_player.fname AS playFname, nfl_player.Lname AS playLname, 
    player_id, nfl_positions.name AS posName, position_id, type FROM nfl_position_player 
INNER JOIN nfl_player 
    ON nfl_position_player.player_id = nfl_player.id  
INNER JOIN nfl_positions 
    ON nfl_position_player.position_id = nfl_positions.id;

-- Get a specific player's positions
SELECT nfl_position_player.id, nfl_player.fname AS playFname,
    nfl_player.Lname AS playLname, player_id, nfl_positions.name AS posName,
    position_id, type FROM nfl_position_player
INNER JOIN nfl_player
    ON nfl_position_player.player_id = nfl_player.id
INNER JOIN nfl_positions ON nfl_position_player.position_id = nfl_positions.id
    WHERE nfl_position_player.id = [playerId];
    
-- =====================================================================================
--                          SELECT for Search Queries
-- =====================================================================================
-- Search for player
SELECT fname, lname FROM nfl_player WHERE nfl_player.id = [playerIdInput];

-- Search for player and associated team
SELECT fname, lname, IFNULL(nfl_team.name, 'No Team') AS teamName FROM nfl_player 
LEFT JOIN nfl_team 
    ON nfl_player.team_id = nfl_team.id
WHERE nfl_player.id = [playerIdInput];

-- Search for player and positions
SELECT fname, lname, IFNULL(nfl_positions.name, 'No position') AS position FROM nfl_player 
LEFT JOIN nfl_position_player 
    ON nfl_player.id = nfl_position_player.player_id
LEFT JOIN nfl_positions
    ON nfl_position_player.position_id = nfl_positions.id
WHERE nfl_player.id = [playerIdInput];


-- Search for player, asssociated team and positions
SELECT fname, lname, IFNULL(nfl_team.name, 'No Team') AS teamName,
        IFNULL(nfl_positions.name, 'No position') AS position
FROM nfl_player 
LEFT JOIN nfl_team 
    ON nfl_player.team_id = nfl_team.id
LEFT JOIN nfl_position_player 
    ON nfl_player.id = nfl_position_player.player_id
LEFT JOIN nfl_positions
    ON nfl_position_player.position_id = nfl_positions.id
WHERE nfl_player.id = [playerIdInput];


-- =====================================================================================
--                          Insert Queries
-- =====================================================================================
-- Make a new division
INSERT INTO nfl_division (name) VALUES ([divisionName]);
-- Make a new player
INSERT INTO nfl_player (fname, lname, team_id, dob, year_drafted, title) VALUES ([firstName],[lastName],[playerTeam],[birthdate],[yearDrafted],[playerTitle]);
-- Make a new position
INSERT INTO nfl_positions (name, type) VALUES ([positionName],[positionType]);
-- Assign a new position a a player
INSERT INTO nfl_position_player (position_id, player_id) VALUES ([position],[player]);
-- Make a new team
INSERT INTO nfl_team (name, year_founded, division_id) VALUES ([teamName],[yearFounded],[division]);
-- Make a new team stat
INSERT INTO nfl_team_stats (year, team_id, wins, losses, ties) VALUES ([year],[team],[numberOfWins],[numberOfLosses],[numberOfTies]);

-- =====================================================================================
--                          UPDATE Queries
-- =====================================================================================
-- Update a division
UPDATE nfl_division SET name=[divisonName] WHERE id=[divisionId];

-- Update a player    
UPDATE nfl_player SET fname=[firstName], lname=[lastName], team_id= [playerTeam], dob=[birthdate], year_drafted=[yearDrafted], title=[playerTitle] WHERE id=[player];

-- Update a position
UPDATE nfl_positions SET name=[positionName], type=[positionType] WHERE id=[position];

-- Update a player's position
UPDATE nfl_position_player SET position_id = [position] WHERE id=[positionPlayerRelationship];

-- Update a team
UPDATE nfl_team SET name=[teamName], year_founded=[yearFounded], division_id=[division] WHERE id=[team];

-- Update team stats
UPDATE nfl_team_stats SET wins= [numberOfWins], losses= [numberOfLosses], ties= [numberOfTies] WHERE team = [team] AND year= [year];

-- =====================================================================================
--                          DELETE Queries
-- =====================================================================================
-- Delete a division
DELETE FROM nfl_division WHERE id = [division];

-- Delete a player            
DELETE FROM nfl_player WHERE id = [player];

-- Delete a position
DELETE FROM nfl_positions WHERE id = [position];

-- Delete a player's position
DELETE FROM nfl_position_player WHERE id = [positionPlayerRelationship];
        
-- Delete a team
DELETE FROM nfl_team WHERE id = [team];

-- Delete team stats
DELETE FROM nfl_team_stats WHERE team_id = [team] AND year = [year];

