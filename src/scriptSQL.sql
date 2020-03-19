CREATE DATABASE MYGAMEWISHLIST;
USE MYGAMEWISHLIST;
#DROP DATABASE MYGAMEWISHLIST;

CREATE TABLE USER(
	ID INT AUTO_INCREMENT,
    NAME VARCHAR(32) NOT NULL,
    EMAIL VARCHAR(320) NOT NULL,
    ADMIN INT(1) DEFAULT 0,
    PRIMARY KEY(ID)
);

CREATE TABLE SHOP(
	ID INT AUTO_INCREMENT,
    NAME VARCHAR(32) NOT NULL,
    PRIMARY KEY(ID)
);

CREATE TABLE GAME(
	ID INT AUTO_INCREMENT,
    NAME VARCHAR(32) NOT NULL,
    DESCRIPTION VARCHAR(256),
    PRIMARY KEY(ID)
);

CREATE TABLE LIST(
	ID_USER INT,
    GAME_URL VARCHAR(2048),
    ID_SHOP INT,
    NAME VARCHAR(32) NOT NULL,
    DEFUALT_PRICE DECIMAL(5,2) NOT NULL,
    LAST_NOTIFIED_PRICE DECIMAL(5,2) DEFAULT NULL,
    MIN_PRICE DECIMAL(5,2) DEFAULT NULL,
    MAX_PRICE DECIMAL(5,2) DEFAULT NULL,
    PRIMARY KEY(ID_USER, GAME_URL),
    FOREIGN KEY (ID_USER) REFERENCES USER(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_SHOP) REFERENCES SHOP(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE REVIEW(
	ID_USER INT,
    ID_GAME INT,
    RATING INT(2) NOT NULL,
    PRIMARY KEY(ID_USER, ID_GAME),
    FOREIGN KEY (ID_USER) REFERENCES USER(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ID_GAME) REFERENCES GAME(ID) ON DELETE CASCADE ON UPDATE CASCADE
);
