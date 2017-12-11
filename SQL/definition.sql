-- Authors: Tiffany Warner and Shane Klumpp
-- Due Date: 12-03-17
-- Description: Final Project: NFL Database
-- Definition file- Defines all tables for the NFL database

DROP TABLE IF EXISTS `nfl_position_player`;
DROP TABLE IF EXISTS `nfl_positions`;
DROP TABLE IF EXISTS `nfl_player`;
DROP TABLE IF EXISTS `nfl_team_stats`;
DROP TABLE IF EXISTS `nfl_team`;
DROP TABLE IF EXISTS `nfl_division`;


-- Divisions Table
CREATE TABLE `nfl_division`(
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) UNIQUE NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Team table
CREATE TABLE `nfl_team`(
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(225) UNIQUE NOT NULL,
    `year_founded` INT NOT NULL,
    `division_id` INT DEFAULT NULL,
    FOREIGN KEY(`division_id`) REFERENCES `nfl_division`(`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Player table
CREATE TABLE `nfl_player`(
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `fname` VARCHAR(225) NOT NULL,
    `lname` VARCHAR(225) NOT NULL,
    `team_id` INT DEFAULT NULL,
    `dob` DATE NOT NULL,
    `year_drafted` INT NOT NULL,
    `title` VARCHAR(225),
    FOREIGN KEY(`team_id`) REFERENCES `nfl_team`(`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Team Stats table
CREATE TABLE `nfl_team_stats`(
    `year` INT NOT NULL,
    `team_id` INT NOT NULL,
    `wins` INT DEFAULT 0,
    `losses` INT DEFAULT 0,
    `ties` INT DEFAULT 0,
    PRIMARY KEY(`year`, `team_id`),
    FOREIGN KEY(`team_id`) REFERENCES `nfl_team`(`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Positions table
CREATE TABLE `nfl_positions`(
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) UNIQUE NOT NULL,
    `type` VARCHAR(255) NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Positions - Players Relationship table
CREATE TABLE `nfl_position_player`(
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `position_id` INT,
    `player_id` INT,
    FOREIGN KEY(`position_id`) REFERENCES `nfl_positions`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(`player_id`) REFERENCES `nfl_player`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_player_position UNIQUE(player_id, position_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Insert Divisions
INSERT INTO nfl_division(`name`) VALUES
    ("American Football Conference East"),
    ("American Football Conference West"),
    ("American Football Conference North"),
    ("American Football Conference South"),
    ("National Football Conference East"),
    ("National Football Conference West"),
    ("National Football Conference North"),
    ("National Football Conference South");

-- Insert Teams
INSERT INTO nfl_team (`name`, `year_founded`, `division_id`) VALUES
    ('Arizona Cardinals', 1898, (SELECT id FROM nfl_division WHERE name="National Football Conference West")), 
    ('Atlanta Falcons', 1965, (SELECT id FROM nfl_division WHERE name="National Football Conference South")), 
    ('Baltimore Ravens', 1996, (SELECT id FROM nfl_division WHERE name="American Football Conference North")), 
    ('Buffalo Bills', 1960, (SELECT id FROM nfl_division WHERE name="American Football Conference East")),
    ('Carolina Panthers', 1993, (SELECT id FROM nfl_division WHERE name="National Football Conference South")), 
    ('Chicago Bears', 1919, (SELECT id FROM nfl_division WHERE name="National Football Conference North")), 
    ('Cincinnati Bengals', 1968, (SELECT id FROM nfl_division WHERE name="American Football Conference North")), 
    ('Cleveland Browns', 1946, (SELECT id FROM nfl_division WHERE name="American Football Conference North")),
    ('Dallas Cowboys', 1960, (SELECT id FROM nfl_division WHERE name="National Football Conference East")), 
    ('Denver Broncos', 1960, (SELECT id FROM nfl_division WHERE name="American Football Conference West")), 
    ('Detroit Lions', 1929, (SELECT id FROM nfl_division WHERE name="National Football Conference North")), 
    ('Green Bay Packers', 1919, (SELECT id FROM nfl_division WHERE name="National Football Conference North")), 
    ('Houston Texans', 2002, (SELECT id FROM nfl_division WHERE name="American Football Conference South")), 
    ('Indianapolis Colts', 1953, (SELECT id FROM nfl_division WHERE name="American Football Conference South")), 
    ('Jacksonville Jaguars', 1993, (SELECT id FROM nfl_division WHERE name="American Football Conference South")), 
    ('Kansas City Chiefs', 1960, (SELECT id FROM nfl_division WHERE name="American Football Conference West")),
    ('Los Angeles Chargers', 1960, (SELECT id FROM nfl_division WHERE name="American Football Conference West")),
    ('Los Angeles Rams', 1936, (SELECT id FROM nfl_division WHERE name="National Football Conference West")), 
    ('Miami Dolphins', 1966, (SELECT id FROM nfl_division WHERE name="American Football Conference East")), 
    ('Minnesota Vikings', 1961, (SELECT id FROM nfl_division WHERE name="National Football Conference North")),
    ('New England Patriots', 1960, (SELECT id FROM nfl_division WHERE name="American Football Conference East")), 
    ('New Orleans Saints', 1967, (SELECT id FROM nfl_division WHERE name="National Football Conference South")), 
    ('New York Giants', 1925, (SELECT id FROM nfl_division WHERE name="National Football Conference East")), 
    ('New York Jets', 1960, (SELECT id FROM nfl_division WHERE name="American Football Conference East")), 
    ('Oakland Raiders', 1960, (SELECT id FROM nfl_division WHERE name="American Football Conference West")), 
    ('Philadelphia Eagles', 1933, (SELECT id FROM nfl_division WHERE name="National Football Conference East")), 
    ('Pittsburgh Steelers', 1933, (SELECT id FROM nfl_division WHERE name="American Football Conference North")), 
    ('San Francisco 49ers', 1946, (SELECT id FROM nfl_division WHERE name="National Football Conference West")),
    ('Seattle Seahawks', 1974, (SELECT id FROM nfl_division WHERE name="National Football Conference West")),
    ('Tampa Bay Buccaneers', 1976, (SELECT id FROM nfl_division WHERE name="National Football Conference South")), 
    ('Tennessee Titans', 1960, (SELECT id FROM nfl_division WHERE name="American Football Conference South")), 
    ('Washington Redskins', 1932, (SELECT id FROM nfl_division WHERE name="National Football Conference East"));

INSERT INTO nfl_positions(`name`, `type`) VALUES
    ('QuarterBack', 'Offense'),
    ('Running Back', 'Offense'),
    ('Wide Receiver', 'Offense'),
    ('Offensive Line', 'Offense'),
    ('Tight End', 'Offense'),
    ('Defensive Back', 'Defense'),
    ('LineBacker', 'Defense'),
    ('Defensive Line', 'Defense'),
    ('Kicker', 'Special Teams'),
    ('Punter', 'Special Teams');


-- Insert Players    
INSERT INTO nfl_player(`fname`, `lname`, `team_id`, `dob`, `year_drafted`, `title`) VALUES
    ('Carson', 'Palmer', (SELECT id FROM nfl_team WHERE name="Arizona Cardinals"), '1979-12-27', 2003, 'captain'), -- QuarterBack
    ('Bryson', 'Albright', (SELECT id FROM nfl_team WHERE name="Arizona Cardinals"), '1994-03-15', 2017, 'player'), -- LineBacker
    ('Larry', 'Fitzgerald', (SELECT id FROM nfl_team WHERE name="Arizona Cardinals"), '1983-08-31', 2004, 'player'), -- Wide Reciever, Running Back
    ('Phil', 'Dawson', (SELECT id FROM nfl_team WHERE name="Arizona Cardinals"), '1975-01-23', 1999, 'player'), -- Kicker
    ('Daniel', 'Munyer', (SELECT id FROM nfl_team WHERE name="Arizona Cardinals"), '1992-03-04', 2015, 'player'),  -- Offensive Line
    
    ('Matt', 'Ryan', (SELECT id FROM nfl_team WHERE name="Atlanta Falcons"), '1985-05-17', 2008, 'captain'), -- QuarterBack
    ('Robert', 'Alford', (SELECT id FROM nfl_team WHERE name="Atlanta Falcons"), '1988-11-01', 2008, 'player'), -- Defensive Back
    ('Matt', 'Bosher', (SELECT id FROM nfl_team WHERE name="Atlanta Falcons"), '1987-10-18', 2011, 'player'),  -- Punter
    
    ('Javorius', 'Allen', (SELECT id FROM nfl_team WHERE name="Baltimore Ravens"), '1991-08-27', 2015, 'player'), -- Running Back
    ('Joe', 'Flacco', (SELECT id FROM nfl_team WHERE name="Baltimore Ravens"), '1985-01-16', 2008, 'captain'), -- QuarterBack
    ('Sam', 'Koch', (SELECT id FROM nfl_team WHERE name="Baltimore Ravens"), '1982-08-13', 2006, 'player'),  -- Punter
    
    ('Eric', 'Wood', (SELECT id FROM nfl_team WHERE name="Buffalo Bills"), '1986-03-18', 2009, 'captain'), -- Offensive Line
    ('Brandon', 'Tate', (SELECT id FROM nfl_team WHERE name="Buffalo Bills"), '1987-05-10', 2009, 'player'), -- Wide Reciever
    ('Logan', 'Thomas', (SELECT id FROM nfl_team WHERE name="Buffalo Bills"), '1991-07-01', 2014, 'player'), -- Tight end
    
    ('Cam', 'Newton', (SELECT id FROM nfl_team WHERE name="Carolina Panthers"), '1989-05-11', 2011, 'captain'),  -- Quarterback, Wide Reciever
    ('Kyle', 'Love', (SELECT id FROM nfl_team WHERE name="Carolina Panthers"), '1986-11-18', 2010, 'player'), -- Defensive Line
    ('Ed', 'Dickson', (SELECT id FROM nfl_team WHERE name="Carolina Panthers"), '1987-07-25', 2010, 'player'), -- Tight End
    
    ('Josh', 'Sitton', (SELECT id FROM nfl_team WHERE name="Chicago Bears"), '1986-06-16', 2008, 'captain'),  -- Offensive Line
    ('Jordan', 'Howard', (SELECT id FROM nfl_team WHERE name="Chicago Bears"), '1994-11-02', 2016, 'player'),  -- Running Back
    ('Jerrell', 'Freeman', (SELECT id FROM nfl_team WHERE name="Chicago Bears"), '1986-05-01', 2012, 'player'),  -- LineBacker
    
    ('Andy', 'Dalton', (SELECT id FROM nfl_team WHERE name="Cincinnati Bengals"), '1987-10-29', 2011, 'captain'), -- Quarterback
    ('Tyler', 'Boyd', (SELECT id FROM nfl_team WHERE name="Cincinnati Bengals"), '1994-11-15', 2016, 'player'), -- Wide Reciever
    ('Tyler', 'Eifert', (SELECT id FROM nfl_team WHERE name="Cincinnati Bengals"), '1990-09-08', 2013, 'player'), -- Tight End
    
    ('Joe', 'Thomas', (SELECT id FROM nfl_team WHERE name="Cleveland Browns"), '1984-12-04', 2007, 'captain'), -- Offensive Line
    ('Zane', 'Gonzalez', (SELECT id FROM nfl_team WHERE name="Cleveland Browns"), '1995-05-07', 2017, 'player'), -- Kicker
    ('Michael', 'Jordan', (SELECT id FROM nfl_team WHERE name="Cleveland Browns"), '1992-10-21', 2016, 'player'), -- Defensive Back
    
    ('Jason', 'Witten', (SELECT id FROM nfl_team WHERE name="Dallas Cowboys"), '1982-05-06', 2003, 'captain'), -- Tight End
    ('Ezekiel', 'Elliot', (SELECT id FROM nfl_team WHERE name="Dallas Cowboys"), '1995-07-22', 2016, 'player'), -- Running Back
    ('Tyrone', 'Crawford', (SELECT id FROM nfl_team WHERE name="Dallas Cowboys"), '1989-11-22', 2012, 'player'), -- Defensive Line
    
    ('Demaryius', 'Thomas', (SELECT id FROM nfl_team WHERE name="Denver Broncos"), '1987-12-25', 2010, 'captain'), -- Wide Reciever
    ('Shane', 'Ray', (SELECT id FROM nfl_team WHERE name="Denver Broncos"), '1993-05-18', 2015, 'player'), -- Line Backer
    ('Domata', 'Peko', (SELECT id FROM nfl_team WHERE name="Denver Broncos"), '1984-11-27', 2006, 'player'), -- Defensive Line
    
    ('Matthew', 'Stafford', (SELECT id FROM nfl_team WHERE name="Detroit Lions"), '1988-02-07', 2009, 'captain'), -- Quarterback
    ('Jamal', 'Agnew', (SELECT id FROM nfl_team WHERE name="Detroit Lions"), '1986-06-16', 2008, 'player'), -- Defensive Back
    ('Jordan', 'Hill', (SELECT id FROM nfl_team WHERE name="Detroit Lions"), '1991-02-08', 2013, 'player'), -- Defensive Line
    
    ('Aaron', 'Rodgers', (SELECT id FROM nfl_team WHERE name="Green Bay Packers"), '1983-12-02', 2005, 'captain'), -- Quarterback
    ('Clay', 'Matthews', (SELECT id FROM nfl_team WHERE name="Green Bay Packers"), '1986-05-14', 2009, 'player'), -- Linebacker, Defensive Line
    ('Kyle', 'Murphy', (SELECT id FROM nfl_team WHERE name="Green Bay Packers"), '1993-12-11', 2016, 'player'), -- Offensive Line
    
    ('JJ', 'Watt', (SELECT id FROM nfl_team WHERE name="Houston Texans"), '1989-03-22', 2011, 'captain'), -- Linebacker, Tight End
    ('Shane', 'Lechler', (SELECT id FROM nfl_team WHERE name="Houston Texans"), '1976-08-07', 2000, 'player'), -- Punter
    ('Nick', 'Martin', (SELECT id FROM nfl_team WHERE name="Houston Texans"), '1993-04-29', 2017, 'player'), -- Offensive Line
    
    ('Andrew', 'Luck', (SELECT id FROM nfl_team WHERE name="Indianapolis Colts"), '1989-09-12', 2012, 'captain'), -- Quarterback
    ('Josh', 'Ferguson', (SELECT id FROM nfl_team WHERE name="Indianapolis Colts"), '1993-05-23', 2016, 'player'), -- Running Back
    ('Frank', 'Gore', (SELECT id FROM nfl_team WHERE name="Indianapolis Colts"), '1983-05-14', 2005, 'player'), -- Running Back
    
    ('Brandon', 'Linder', (SELECT id FROM nfl_team WHERE name="Jacksonville Jaguars"), '1992-01-25', 2014, 'captain'), -- Offensive Line
    ('Brad', 'Nortman', (SELECT id FROM nfl_team WHERE name="Jacksonville Jaguars"), '1989-09-12', 2012, 'player'), -- Punter
    ('Josh', 'Lambo', (SELECT id FROM nfl_team WHERE name="Jacksonville Jaguars"), '1990-11-19', 2015, 'player'), -- Kicker
    
    ('Alex', 'Smith', (SELECT id FROM nfl_team WHERE name="Kansas City Chiefs"), '1984-05-07', 2005, 'captain'), -- Quarterback
    ('Travis', 'Kelce', (SELECT id FROM nfl_team WHERE name="Kansas City Chiefs"), '1989-10-05', 2013, 'player'), -- Tight End
    ('Kareem', 'Hunt', (SELECT id FROM nfl_team WHERE name="Kansas City Chiefs"), '1995-08-06', 2017, 'player'), -- Running Back
    
    ('Philip', 'Rivers', (SELECT id FROM nfl_team WHERE name="Los Angeles Chargers"), '1981-12-08', 2004, 'captain'), -- QuarterBack
    ('Antonio', 'Gates', (SELECT id FROM nfl_team WHERE name="Los Angeles Chargers"), '1980-06-18', 2003, 'player'), -- TightEnd, Offensive Line
    ('Melvin', 'Gordon', (SELECT id FROM nfl_team WHERE name="Los Angeles Chargers"), '1993-04-13', 2015, 'player'), -- Running Back
    
    ('Todd', 'Gurley', (SELECT id FROM nfl_team WHERE name="Los Angeles Rams"), '1994-08-03', 2015, 'captain'), -- Running Back
    ('Greg', 'Zuerlein', (SELECT id FROM nfl_team WHERE name="Los Angeles Rams"), '1990-01-01', 2012, 'player'), -- Kicker
    ('Troy', 'Hill', (SELECT id FROM nfl_team WHERE name="Los Angeles Rams"), '1991-08-29', 2015, 'player'), -- Defensive Back
    
    ('Kenny', 'Stills', (SELECT id FROM nfl_team WHERE name="Miami Dolphins"), '1992-04-02', 2013, 'captain'), -- Wide Reciever, Tight End
    ('Jordan', 'Phillips', (SELECT id FROM nfl_team WHERE name="Miami Dolphins"), '1992-10-15', 2015, 'player'), -- Defensive Line
    ('Matt', 'Haack', (SELECT id FROM nfl_team WHERE name="Miami Dolphins"), '1994-07-25', 2017, 'player'), -- Punter
    
    ('Kyle', 'Rudolph', (SELECT id FROM nfl_team WHERE name="Minnesota Vikings"), '1989-11-09', 2011, 'captain'), -- Tight End
    ('Tom', 'Johnson', (SELECT id FROM nfl_team WHERE name="Minnesota Vikings"), '1984-08-30', 2011, 'player'), -- Defensive Line
    ('Eric', 'Wilson', (SELECT id FROM nfl_team WHERE name="Minnesota Vikings"), '1994-09-26', 2017, 'player'), -- LineBacker
    
    ('Tom', 'Brady', (SELECT id FROM nfl_team WHERE name="New England Patriots"), '1977-08-03', 2000, 'captain'), -- QuarterBack
    ('Rob', 'Gronkowski', (SELECT id FROM nfl_team WHERE name="New England Patriots"), '1989-05-14', 2010, 'player'), -- Tight End, Wide Reciever
    ('Julian', 'Edelman', (SELECT id FROM nfl_team WHERE name="New England Patriots"), '1986-05-22', 2009, 'player'), -- Wide Reciever, Running Back
    
    ('Drew', 'Brees', (SELECT id FROM nfl_team WHERE name="New Orleans Saints"), '1979-01-15', 2001, 'captain'), -- QuarterBack
    ('Mark', 'Ingram', (SELECT id FROM nfl_team WHERE name="New Orleans Saints"), '1989-12-21', 2011, 'player'), -- Running Back
    ('Thomas', 'Morstead', (SELECT id FROM nfl_team WHERE name="New Orleans Saints"), '1986-03-08', 2009, 'player'), -- Punter, Kicker
    
    ('Eli', 'Manning', (SELECT id FROM nfl_team WHERE name="New York Giants"), '1981-01-03', 2004, 'captain'), -- QuarterBack
    ('Damon', 'Harrison', (SELECT id FROM nfl_team WHERE name="New York Giants"), '1988-11-29', 2012, 'player'), -- Defensive Line
    ('Odell', 'Beckham', (SELECT id FROM nfl_team WHERE name="New York Giants"), '1992-11-05', 2014, 'player'), -- Wide Reciever
    
    ('Josh', 'Mccowen', (SELECT id FROM nfl_team WHERE name="New York Jets"), '1979-07-04', 2002, 'captain'), -- QuarterBack
    ('Josh', 'Martin', (SELECT id FROM nfl_team WHERE name="New York Jets"), '1991-11-07', 2013, 'player'), -- Wide Reciever
    ('Matt', 'Forte', (SELECT id FROM nfl_team WHERE name="New York Jets"), '1985-12-10', 2008, 'player'), -- Running Back
    
    ('Derek', 'Carr', (SELECT id FROM nfl_team WHERE name="Oakland Raiders"), '1991-01-16', 2014, 'captain'), -- Quarterback
    ('James', 'Cowser', (SELECT id FROM nfl_team WHERE name="Oakland Raiders"), '1990-09-13', 2010, 'player'), -- Defensive Line
    ('Marshawn', 'Lynch', (SELECT id FROM nfl_team WHERE name="Oakland Raiders"), '1986-04-22', 2007, 'player'), -- Running Back
    
    ('Carson', 'Wentz', (SELECT id FROM nfl_team WHERE name="Philadelphia Eagles"), '1992-12-30', 2016, 'captain'), -- QuarterBack
    ('Caleb', 'Sturgis', (SELECT id FROM nfl_team WHERE name="Philadelphia Eagles"), '1989-08-09', 2013, 'player'), -- Kicker
    ('Malcon', 'Jenkins', (SELECT id FROM nfl_team WHERE name="Philadelphia Eagles"), '1987-12-20', 2009, 'player'), -- Defensive Back
    
    ('Ben', 'Roethlisberger', (SELECT id FROM nfl_team WHERE name="Pittsburgh Steelers"), '1982-03-02', 2004, 'captain'), -- QuarterBack
    ('Antonio', 'Brown', (SELECT id FROM nfl_team WHERE name="Pittsburgh Steelers"), '1988-07-10', 2010, 'player'), -- Wide Reciever, Running Back
    ('Artie', 'Burns', (SELECT id FROM nfl_team WHERE name="Pittsburgh Steelers"), '1995-05-01', 2016, 'player'), -- Defensive Back
    
    ('Elijah', 'Lee', (SELECT id FROM nfl_team WHERE name="San Francisco 49ers"), '1996-02-08', 2017, 'captain'), -- LineBacker
    ('Bradley', 'Pinion', (SELECT id FROM nfl_team WHERE name="San Francisco 49ers"), '1994-06-01', 2015, 'player'), -- Punter
    ('Leon', 'Hall', (SELECT id FROM nfl_team WHERE name="San Francisco 49ers"), '1984-12-09', 2007, 'player'), -- Defensive Back
    
    ('Russel', 'Wilson', (SELECT id FROM nfl_team WHERE name="Seattle Seahawks"), '1988-11-29', 2012, 'captain'), -- QuarterBack
    ('Richard', 'Sherman', (SELECT id FROM nfl_team WHERE name="Seattle Seahawks"), '1988-03-30', 2011, 'player'), -- Defensive Back
    ('Tyler', 'Lockett', (SELECT id FROM nfl_team WHERE name="Seattle Seahawks"), '1992-09-28', 2015, 'player'),  -- Wide Receiver, Running Back
    
    ('Jameis', 'Winston', (SELECT id FROM nfl_team WHERE name="Tampa Bay Buccaneers"), '1994-01-06', 2015, 'captain'), -- QuarterBack
    ('TJ', 'Ward', (SELECT id FROM nfl_team WHERE name="Tampa Bay Buccaneers"), '1986-12-12', 2010, 'player'), -- Defensive Back
    ('Chris', 'Conte', (SELECT id FROM nfl_team WHERE name="Tampa Bay Buccaneers"), '1989-02-03', 2011, 'player'), -- Defensive Back
    
    ('Marcus', 'Mariotta', (SELECT id FROM nfl_team WHERE name="Tennessee Titans"), '1993-10-30', 2015, 'captain'), -- QuarterBack
    ('Derrick', 'Henry', (SELECT id FROM nfl_team WHERE name="Tennessee Titans"), '1994-01-04', 2016, 'player'), -- Running Back
    ('Josh', 'Kline', (SELECT id FROM nfl_team WHERE name="Tennessee Titans"), '1989-12-29', 2013, 'player'), -- Offensive Line
    
    ('Trent', 'Williams', (SELECT id FROM nfl_team WHERE name="Washington Redskins"), '1988-07-19', 2010, 'captain'), -- Offensive Line
    ('Nick', 'Rose', (SELECT id FROM nfl_team WHERE name="Washington Redskins"), '1994-05-05', 2017, 'player'), -- Kicker
    ('Zach', 'Brown', (SELECT id FROM nfl_team WHERE name="Washington Redskins"), '1989-10-23', 2012, 'player'); -- LineBacker
    

-- Data from  http://www.espn.com/nfl/standings/_/season/2016   
INSERT INTO nfl_team_stats(`year`, `team_id`, `wins`, `losses`, `ties`) VALUES
    (2016, (SELECT id FROM nfl_team WHERE name="New England Patriots"), 14, 2, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Miami Dolphins"), 10, 6, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Buffalo Bills"), 7, 9, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="New York Jets"), 5, 11, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Pittsburgh Steelers"), 11, 5, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Baltimore Ravens"), 8, 8, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Cincinnati Bengals"), 6, 9, 1),
    (2016, (SELECT id FROM nfl_team WHERE name="Cleveland Browns"), 1, 15, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Houston Texans"), 9, 7, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Tennessee Titans"), 9, 7, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Indianapolis Colts"), 8, 8, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Jacksonville Jaguars"), 3, 13, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Kansas City Chiefs"), 12, 4, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Oakland Raiders"), 12, 4, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Denver Broncos"), 9, 7, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Los Angeles Chargers"), 5, 11, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Dallas Cowboys"), 13, 3, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="New York Giants"), 11, 5, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Washington Redskins"), 8, 7, 1),
    (2016, (SELECT id FROM nfl_team WHERE name="Philadelphia Eagles"), 7, 9, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Green Bay Packers"), 10, 6, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Detroit Lions"), 9, 7, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Minnesota Vikings"), 8, 8, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Chicago Bears"), 3, 13, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Atlanta Falcons"), 11, 5, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Tampa Bay Buccaneers"), 9, 7, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="New Orleans Saints"), 7, 9, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Carolina Panthers"), 6, 10, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="Seattle Seahawks"), 10, 5, 1),
    (2016, (SELECT id FROM nfl_team WHERE name="Arizona Cardinals"), 7, 8, 1),
    (2016, (SELECT id FROM nfl_team WHERE name="Los Angeles Rams"), 4, 12, 0),
    (2016, (SELECT id FROM nfl_team WHERE name="San Francisco 49ers"), 2, 14, 0),
        
    (2015, (SELECT id FROM nfl_team WHERE name="New England Patriots"), 12, 4, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Miami Dolphins"), 6, 10, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Buffalo Bills"), 8, 8, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="New York Jets"), 10, 6, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Pittsburgh Steelers"), 10, 6, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Baltimore Ravens"), 5, 11, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Cincinnati Bengals"), 12, 4, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Cleveland Browns"), 3, 13, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Houston Texans"), 9, 7, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Tennessee Titans"), 3, 13, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Indianapolis Colts"), 8, 8, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Jacksonville Jaguars"), 5, 11, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Kansas City Chiefs"), 11, 5, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Oakland Raiders"), 7, 9, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Denver Broncos"), 12, 4, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Los Angeles Chargers"), 4, 12, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Dallas Cowboys"), 4, 12, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="New York Giants"), 6, 10, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Washington Redskins"), 9, 7, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Philadelphia Eagles"), 7, 9, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Green Bay Packers"), 10, 6, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Detroit Lions"), 7, 9, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Minnesota Vikings"), 11, 5, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Chicago Bears"), 6, 10, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Atlanta Falcons"), 8, 8, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Tampa Bay Buccaneers"), 6, 10, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="New Orleans Saints"), 7, 9, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Carolina Panthers"), 15, 1, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Seattle Seahawks"), 10, 6, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Arizona Cardinals"), 13, 3, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="Los Angeles Rams"), 7, 9, 0),
    (2015, (SELECT id FROM nfl_team WHERE name="San Francisco 49ers"), 5, 11, 0);
    
    
    
    
 INSERT INTO nfl_position_player(`position_id`, `player_id`) VALUES 
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Carson" AND lname="Palmer" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Matt" AND lname="Ryan" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Joe" AND lname="Flacco" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Cam" AND lname="Newton" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Andy" AND lname="Dalton" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Matthew" AND lname="Stafford" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Aaron" AND lname="Rodgers" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Andrew" AND lname="Luck" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Alex" AND lname="Smith" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Philip" AND lname="Rivers" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Tom" AND lname="Brady" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Drew" AND lname="Brees" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Eli" AND lname="Manning" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Josh" AND lname="Mccowen" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Derek" AND lname="Carr" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Carson" AND lname="Wentz" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Ben" AND lname="Roethlisberger" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Russel" AND lname="Wilson" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Jameis" AND lname="Winston" )),
     ((SELECT id FROM nfl_positions WHERE name="QuarterBack"), (SELECT id FROM nfl_player WHERE fname="Marcus" AND lname="Mariotta" )),
     
     ((SELECT id FROM nfl_positions WHERE name="Running Back"), (SELECT id FROM nfl_player WHERE fname="Cam" AND lname="Newton" )),
     ((SELECT id FROM nfl_positions WHERE name="Running Back"), (SELECT id FROM nfl_player WHERE fname="Larry" AND lname="Fitzgerald" )),
     ((SELECT id FROM nfl_positions WHERE name="Running Back"), (SELECT id FROM nfl_player WHERE fname="Javorius" AND lname="Allen" )),
     ((SELECT id FROM nfl_positions WHERE name="Running Back"), (SELECT id FROM nfl_player WHERE fname="Jordan" AND lname="Howard" )),
     ((SELECT id FROM nfl_positions WHERE name="Running Back"), (SELECT id FROM nfl_player WHERE fname="Ezekiel" AND lname="Elliot" )),
     ((SELECT id FROM nfl_positions WHERE name="Running Back"), (SELECT id FROM nfl_player WHERE fname="Josh" AND lname="Ferguson" )),
     ((SELECT id FROM nfl_positions WHERE name="Running Back"), (SELECT id FROM nfl_player WHERE fname="Frank" AND lname="Gore" )),
     ((SELECT id FROM nfl_positions WHERE name="Running Back"), (SELECT id FROM nfl_player WHERE fname="Kareem" AND lname="Hunt" )),
     ((SELECT id FROM nfl_positions WHERE name="Running Back"), (SELECT id FROM nfl_player WHERE fname="Melvin" AND lname="Gordon" )),
     ((SELECT id FROM nfl_positions WHERE name="Running Back"), (SELECT id FROM nfl_player WHERE fname="Todd" AND lname="Gurley" )),
     ((SELECT id FROM nfl_positions WHERE name="Running Back"), (SELECT id FROM nfl_player WHERE fname="Julian" AND lname="Edelman" )),
     ((SELECT id FROM nfl_positions WHERE name="Running Back"), (SELECT id FROM nfl_player WHERE fname="Mark" AND lname="Ingram" )),
     ((SELECT id FROM nfl_positions WHERE name="Running Back"), (SELECT id FROM nfl_player WHERE fname="Matt" AND lname="Forte" )),
     ((SELECT id FROM nfl_positions WHERE name="Running Back"), (SELECT id FROM nfl_player WHERE fname="Marshawn" AND lname="Lynch" )),
     ((SELECT id FROM nfl_positions WHERE name="Running Back"), (SELECT id FROM nfl_player WHERE fname="Antonio" AND lname="Brown" )),
     ((SELECT id FROM nfl_positions WHERE name="Running Back"), (SELECT id FROM nfl_player WHERE fname="Tyler" AND lname="Lockett" )),
     ((SELECT id FROM nfl_positions WHERE name="Running Back"), (SELECT id FROM nfl_player WHERE fname="Derrick" AND lname="Henry" )),
     
     ((SELECT id FROM nfl_positions WHERE name="Wide Receiver"), (SELECT id FROM nfl_player WHERE fname="Larry" AND lname="Fitzgerald" )),
     ((SELECT id FROM nfl_positions WHERE name="Wide Receiver"), (SELECT id FROM nfl_player WHERE fname="Brandon" AND lname="Tate" )),
     ((SELECT id FROM nfl_positions WHERE name="Wide Receiver"), (SELECT id FROM nfl_player WHERE fname="Tyler" AND lname="Boyd" )),
     ((SELECT id FROM nfl_positions WHERE name="Wide Receiver"), (SELECT id FROM nfl_player WHERE fname="Demaryius" AND lname="Thomas" )),
     ((SELECT id FROM nfl_positions WHERE name="Wide Receiver"), (SELECT id FROM nfl_player WHERE fname="Kareem" AND lname="Hunt" )),
     ((SELECT id FROM nfl_positions WHERE name="Wide Receiver"), (SELECT id FROM nfl_player WHERE fname="Melvin" AND lname="Gordon" )),
     ((SELECT id FROM nfl_positions WHERE name="Wide Receiver"), (SELECT id FROM nfl_player WHERE fname="Kenny" AND lname="Stills" )),
     ((SELECT id FROM nfl_positions WHERE name="Wide Receiver"), (SELECT id FROM nfl_player WHERE fname="Rob" AND lname="Gronkowski" )),
     ((SELECT id FROM nfl_positions WHERE name="Wide Receiver"), (SELECT id FROM nfl_player WHERE fname="Julian" AND lname="Edelman" )),
     ((SELECT id FROM nfl_positions WHERE name="Wide Receiver"), (SELECT id FROM nfl_player WHERE fname="Odell" AND lname="Beckham" )),
     ((SELECT id FROM nfl_positions WHERE name="Wide Receiver"), (SELECT id FROM nfl_player WHERE fname="Josh" AND lname="Martin" )),
     ((SELECT id FROM nfl_positions WHERE name="Wide Receiver"), (SELECT id FROM nfl_player WHERE fname="Antonio" AND lname="Brown" )),
     ((SELECT id FROM nfl_positions WHERE name="Wide Receiver"), (SELECT id FROM nfl_player WHERE fname="Tyler" AND lname="Lockett" )),

     ((SELECT id FROM nfl_positions WHERE name="Offensive Line"), (SELECT id FROM nfl_player WHERE fname="Daniel" AND lname="Munyer" )),
     ((SELECT id FROM nfl_positions WHERE name="Offensive Line"), (SELECT id FROM nfl_player WHERE fname="Eric" AND lname="Wood" )),
     ((SELECT id FROM nfl_positions WHERE name="Offensive Line"), (SELECT id FROM nfl_player WHERE fname="Josh" AND lname="Sitton" )),
     ((SELECT id FROM nfl_positions WHERE name="Offensive Line"), (SELECT id FROM nfl_player WHERE fname="Joe" AND lname="Thomas" )),
     ((SELECT id FROM nfl_positions WHERE name="Offensive Line"), (SELECT id FROM nfl_player WHERE fname="Jason" AND lname="Witten" )),
     ((SELECT id FROM nfl_positions WHERE name="Offensive Line"), (SELECT id FROM nfl_player WHERE fname="Kyle" AND lname="Murphy" )),
     ((SELECT id FROM nfl_positions WHERE name="Offensive Line"), (SELECT id FROM nfl_player WHERE fname="Nick" AND lname="Martin" )),
     ((SELECT id FROM nfl_positions WHERE name="Offensive Line"), (SELECT id FROM nfl_player WHERE fname="Brandon" AND lname="Linder" )),
     ((SELECT id FROM nfl_positions WHERE name="Offensive Line"), (SELECT id FROM nfl_player WHERE fname="Travis" AND lname="Kelce" )),
     ((SELECT id FROM nfl_positions WHERE name="Offensive Line"), (SELECT id FROM nfl_player WHERE fname="Antonio" AND lname="Gates" )),
     ((SELECT id FROM nfl_positions WHERE name="Offensive Line"), (SELECT id FROM nfl_player WHERE fname="Josh" AND lname="Kline" )),
     ((SELECT id FROM nfl_positions WHERE name="Offensive Line"), (SELECT id FROM nfl_player WHERE fname="Trent" AND lname="Williams" )),

     ((SELECT id FROM nfl_positions WHERE name="Tight End"), (SELECT id FROM nfl_player WHERE fname="Logan" AND lname="Thomas" )),
     ((SELECT id FROM nfl_positions WHERE name="Tight End"), (SELECT id FROM nfl_player WHERE fname="Ed" AND lname="Dickson" )),
     ((SELECT id FROM nfl_positions WHERE name="Tight End"), (SELECT id FROM nfl_player WHERE fname="Tyler" AND lname="Eifert" )),
     ((SELECT id FROM nfl_positions WHERE name="Tight End"), (SELECT id FROM nfl_player WHERE fname="Jason" AND lname="Witten" )),
     ((SELECT id FROM nfl_positions WHERE name="Tight End"), (SELECT id FROM nfl_player WHERE fname="Kyle" AND lname="Murphy" )),
     ((SELECT id FROM nfl_positions WHERE name="Tight End"), (SELECT id FROM nfl_player WHERE fname="JJ" AND lname="Watt" )),
     ((SELECT id FROM nfl_positions WHERE name="Tight End"), (SELECT id FROM nfl_player WHERE fname="Travis" AND lname="Kelce" )),
     ((SELECT id FROM nfl_positions WHERE name="Tight End"), (SELECT id FROM nfl_player WHERE fname="Antonio" AND lname="Gates" )),
     ((SELECT id FROM nfl_positions WHERE name="Tight End"), (SELECT id FROM nfl_player WHERE fname="Kenny" AND lname="Stills" )),
     ((SELECT id FROM nfl_positions WHERE name="Tight End"), (SELECT id FROM nfl_player WHERE fname="Kyle" AND lname="Rudolph" )),
     ((SELECT id FROM nfl_positions WHERE name="Tight End"), (SELECT id FROM nfl_player WHERE fname="Rob" AND lname="Gronkowski" )),

     ((SELECT id FROM nfl_positions WHERE name="Defensive Back"), (SELECT id FROM nfl_player WHERE fname="Robert" AND lname="Alford" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Back"), (SELECT id FROM nfl_player WHERE fname="Michael" AND lname="Jordan" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Back"), (SELECT id FROM nfl_player WHERE fname="Jamal" AND lname="Agnew" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Back"), (SELECT id FROM nfl_player WHERE fname="Tro" AND lname="Hill" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Back"), (SELECT id FROM nfl_player WHERE fname="Malcon" AND lname="Jenkins" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Back"), (SELECT id FROM nfl_player WHERE fname="Artie" AND lname="Burns" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Back"), (SELECT id FROM nfl_player WHERE fname="Leon" AND lname="Hall" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Back"), (SELECT id FROM nfl_player WHERE fname="Richard" AND lname="Sherman" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Back"), (SELECT id FROM nfl_player WHERE fname="TJ" AND lname="Ward" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Back"), (SELECT id FROM nfl_player WHERE fname="Chris" AND lname="Conte" )),

     ((SELECT id FROM nfl_positions WHERE name="Defensive Line"), (SELECT id FROM nfl_player WHERE fname="Kyle" AND lname="Love" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Line"), (SELECT id FROM nfl_player WHERE fname="Tyrone" AND lname="Crawford" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Line"), (SELECT id FROM nfl_player WHERE fname="Shane" AND lname="Ray" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Line"), (SELECT id FROM nfl_player WHERE fname="Domata" AND lname="Peko" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Line"), (SELECT id FROM nfl_player WHERE fname="Jordan" AND lname="Hill" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Line"), (SELECT id FROM nfl_player WHERE fname="Clay" AND lname="Matthews" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Line"), (SELECT id FROM nfl_player WHERE fname="Troy" AND lname="Hill" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Line"), (SELECT id FROM nfl_player WHERE fname="Jordan" AND lname="Phillips" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Line"), (SELECT id FROM nfl_player WHERE fname="Tom" AND lname="Johnson" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Line"), (SELECT id FROM nfl_player WHERE fname="Damon" AND lname="Harrison" )),
     ((SELECT id FROM nfl_positions WHERE name="Defensive Line"), (SELECT id FROM nfl_player WHERE fname="James" AND lname="Cowser" )),

     ((SELECT id FROM nfl_positions WHERE name="LineBacker"), (SELECT id FROM nfl_player WHERE fname="Bryson" AND lname="Albright" )),
     ((SELECT id FROM nfl_positions WHERE name="LineBacker"), (SELECT id FROM nfl_player WHERE fname="Jerrell" AND lname="Freeman" )),
     ((SELECT id FROM nfl_positions WHERE name="LineBacker"), (SELECT id FROM nfl_player WHERE fname="Shane" AND lname="Ray" )),
     ((SELECT id FROM nfl_positions WHERE name="LineBacker"), (SELECT id FROM nfl_player WHERE fname="Clay" AND lname="Matthews" )),
     ((SELECT id FROM nfl_positions WHERE name="LineBacker"), (SELECT id FROM nfl_player WHERE fname="JJ" AND lname="Watt" )),
     ((SELECT id FROM nfl_positions WHERE name="LineBacker"), (SELECT id FROM nfl_player WHERE fname="Eric" AND lname="Wilson" )),
     ((SELECT id FROM nfl_positions WHERE name="LineBacker"), (SELECT id FROM nfl_player WHERE fname="Elijah" AND lname="Lee" )),
     ((SELECT id FROM nfl_positions WHERE name="LineBacker"), (SELECT id FROM nfl_player WHERE fname="Zach" AND lname="Brown" )),

     ((SELECT id FROM nfl_positions WHERE name="Kicker"), (SELECT id FROM nfl_player WHERE fname="Phil" AND lname="Dawson" )),
     ((SELECT id FROM nfl_positions WHERE name="Kicker"), (SELECT id FROM nfl_player WHERE fname="Zane" AND lname="Gonzalez" )),
     ((SELECT id FROM nfl_positions WHERE name="Kicker"), (SELECT id FROM nfl_player WHERE fname="Josh" AND lname="Lambo" )),
     ((SELECT id FROM nfl_positions WHERE name="Kicker"), (SELECT id FROM nfl_player WHERE fname="Greg" AND lname="Zuerlein" )),
     ((SELECT id FROM nfl_positions WHERE name="Kicker"), (SELECT id FROM nfl_player WHERE fname="Thomas" AND lname="Morstead" )),
     ((SELECT id FROM nfl_positions WHERE name="Kicker"), (SELECT id FROM nfl_player WHERE fname="Caleb" AND lname="Sturgis" )),
     ((SELECT id FROM nfl_positions WHERE name="Kicker"), (SELECT id FROM nfl_player WHERE fname="Nick" AND lname="Rose" )),

     ((SELECT id FROM nfl_positions WHERE name="Punter"), (SELECT id FROM nfl_player WHERE fname="Matt" AND lname="Bosher" )),
     ((SELECT id FROM nfl_positions WHERE name="Punter"), (SELECT id FROM nfl_player WHERE fname="Sam" AND lname="Koch" )),
     ((SELECT id FROM nfl_positions WHERE name="Punter"), (SELECT id FROM nfl_player WHERE fname="Shane" AND lname="Lechler" )),
     ((SELECT id FROM nfl_positions WHERE name="Punter"), (SELECT id FROM nfl_player WHERE fname="Brad" AND lname="Nortman" )),
     ((SELECT id FROM nfl_positions WHERE name="Punter"), (SELECT id FROM nfl_player WHERE fname="Josh" AND lname="Lambo" )),
     ((SELECT id FROM nfl_positions WHERE name="Punter"), (SELECT id FROM nfl_player WHERE fname="Matt" AND lname="Haack" )),
     ((SELECT id FROM nfl_positions WHERE name="Punter"), (SELECT id FROM nfl_player WHERE fname="Thomas" AND lname="Morstead" )),
     ((SELECT id FROM nfl_positions WHERE name="Punter"), (SELECT id FROM nfl_player WHERE fname="Bradley" AND lname="Pinion" ));

--     ((SELECT id FROM nfl_position WHERE name=""), (SELECT id FROM nfl_player WHERE name="")),
--     ((SELECT id FROM nfl_position WHERE name=""), (SELECT id FROM nfl_player WHERE name="")),
--     ((SELECT id FROM nfl_position WHERE name=""), (SELECT id FROM nfl_player WHERE name="")),
--     ((SELECT id FROM nfl_position WHERE name=""), (SELECT id FROM nfl_player WHERE name=""));