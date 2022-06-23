DROP TABLE IF EXISTS teams
         , games CASCADE
;

CREATE TABLE teams
   (
        team_id SERIAL NOT NULL PRIMARY KEY
      , name VARCHAR UNIQUE NOT NULL
   )
;

CREATE TABLE games
   (
        game_id        SERIAL PRIMARY KEY NOT NULL
      , year           INT NOT NULL
      , round          VARCHAR NOT NULL
      , winner_id      INT NOT NULL
      , opponent_id    INT NOT NULL
      , winner_goals   INT NOT NULL
      , opponent_goals INT NOT NULL
      , FOREIGN KEY (winner_id) REFERENCES teams (team_id)
      , FOREIGN KEY (opponent_id) REFERENCES teams (team_id)
   )
;
