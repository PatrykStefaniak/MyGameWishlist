CREATE DATABASE MYGAMEWISHLIST;
USE MYGAMEWISHLIST;
#DROP DATABASE MYGAMEWISHLIST;

CREATE TABLE USER(
	ID INT AUTO_INCREMENT,
    NAME VARCHAR(32) NOT NULL,
    EMAIL VARCHAR(320) NOT NULL UNIQUE,
    ADMIN INT(1) DEFAULT 0,
    PRIMARY KEY(ID)
);

CREATE TABLE STORE(
	ID INT AUTO_INCREMENT,
    NAME VARCHAR(32) NOT NULL,
    URL VARCHAR(256) UNIQUE NOT NULL,
    QUERY_PART VARCHAR(128),
    IMG VARCHAR(16),
    PRIMARY KEY(ID)
);

CREATE TABLE STEAM_GAMES(
	APPID INT,
    NAME VARCHAR(256) NOT NULL,
    PRIMARY KEY(APPID)
);

CREATE TABLE WISHLIST_GAME_PRICE_TIMELINE(
	ID INT AUTO_INCREMENT UNIQUE,
	URL VARCHAR(256),
    ID_STORE INT NOT NULL,
    IMG VARCHAR(256) DEFAULT "",
    NAME VARCHAR(256) NOT NULL,
    DEFAULT_PRICE DECIMAL(5,2) NOT NULL,
    CURRENT_PRICE DECIMAL(5,2) NOT NULL, 
    STEAM_APPID INT,
    PRIMARY KEY(URL),
    FOREIGN KEY (ID_STORE) REFERENCES STORE(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (STEAM_APPID) REFERENCES STEAM_GAMES(APPID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE PRICE_TIMELINE(
	ID_URL INT,
    TIME DATE,
    PRICE DECIMAL(5,2),
    DISCOUNT DECIMAL(5,2),
    PRIMARY KEY(ID_URL, TIME),
    FOREIGN KEY (ID_URL) REFERENCES WISHLIST_GAME_PRICE_TIMELINE(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE WISHLIST_GAME(
	ID_URL INT,
    ID_USER INT,
    MIN_PRICE DECIMAL(5,2) DEFAULT -1,
    MAX_PRICE DECIMAL(5,2) DEFAULT -1,
    PRIMARY KEY(ID_URL, ID_USER),
    FOREIGN KEY (ID_USER) REFERENCES USER(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_URL) REFERENCES WISHLIST_GAME_PRICE_TIMELINE(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE SECRET_VARIABLES(
	NAME VARCHAR(16),
    VALUE VARCHAR(64),
    PRIMARY KEY(NAME)
);

DELIMITER $$
CREATE TRIGGER DELETE_TIMELINE BEFORE DELETE ON WISHLIST_GAME
	FOR EACH ROW
    BEGIN
		DECLARE USERS INT;
        SET USERS := (SELECT ID_USER FROM WISHLIST_GAME 
			WHERE ID_USER != OLD.ID_USER AND ID_URL = OLD.ID_URL LIMIT 1);
        
        IF (USERS IS NULL) THEN
			DELETE FROM PRICE_TIMELINE WHERE ID_URL = OLD.ID_URL AND TIME > 0;
            DELETE FROM WISHLIST_GAME_PRICE_TIMELINE WHERE ID = OLD.ID_URL;
        END IF;
	END$$
DELIMITER ;

CREATE TABLE DEVELOPER(
	ID INT AUTO_INCREMENT,
    NAME VARCHAR(64) NOT NULL UNIQUE,
    PRIMARY KEY(ID)
);

CREATE TABLE GAME(
	ID INT AUTO_INCREMENT,
    NAME VARCHAR(32) UNIQUE,
    DESCRIPTION VARCHAR(256),
    RELEASE_DATE DATE NOT NULL,
    ID_DEVELOPER INT NOT NULL,
    PRIMARY KEY(ID),
    FOREIGN KEY (ID_DEVELOPER) REFERENCES DEVELOPER(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE REVIEW(
	ID_USER INT,
    ID_GAME INT,
    RATING DECIMAL(3,1) NOT NULL,
    REVIEW VARCHAR(256),
    PRIMARY KEY(ID_USER, ID_GAME),
    FOREIGN KEY (ID_USER) REFERENCES USER(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_GAME) REFERENCES GAME(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE GENRE(
	ID INT AUTO_INCREMENT,
    NAME VARCHAR(48) UNIQUE,
    PRIMARY KEY(ID)
);

CREATE TABLE GAME_GENRE(
	ID_GAME INT,
    ID_GENRE INT,
    PRIMARY KEY(ID_GAME,ID_GENRE),
    FOREIGN KEY (ID_GAME) REFERENCES GAME(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_GENRE) REFERENCES GENRE(ID) ON DELETE CASCADE ON UPDATE CASCADE
);