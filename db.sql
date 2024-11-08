create database hafilaty;
use hafilaty;


CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    psw VARCHAR(255) NOT NULL
);

CREATE TABLE likedplace (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    stop_id INT NOT NULL,
    location VARCHAR(255),
    name VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (stop_id) REFERENCES stop(id)
);

CREATE TABLE route (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    start_stop INT NOT NULL,
    end_stop INT NOT NULL,
    url_to_share VARCHAR(255),
    FOREIGN KEY (start_stop) REFERENCES stop(id),
    FOREIGN KEY (end_stop) REFERENCES stop(id)
);


CREATE TABLE trip (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    route_id INT NOT NULL,
    beg DATETIME NOT NULL,  -- start time
    end DATETIME NOT NULL,  -- end time
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (route_id) REFERENCES route(id)
);


CREATE TABLE stop (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL
);


CREATE TABLE belongs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    stop_id INT NOT NULL,
    route_id INT NOT NULL,
    FOREIGN KEY (stop_id) REFERENCES stop(id),
    FOREIGN KEY (route_id) REFERENCES route(id)
);


CREATE TABLE bus (
    id INT PRIMARY KEY AUTO_INCREMENT,
    driver_id INT NOT NULL,
    matricule VARCHAR(100) NOT NULL,
    route_id INT NOT NULL,
    FOREIGN KEY (driver_id) REFERENCES driver(id),
    FOREIGN KEY (route_id) REFERENCES route(id)
);

CREATE TABLE schedule (
    id INT PRIMARY KEY AUTO_INCREMENT,
    bus_id INT NOT NULL,
    stop_id INT NOT NULL,
    time TIME NOT NULL,
    FOREIGN KEY (bus_id) REFERENCES bus(id),
    FOREIGN KEY (stop_id) REFERENCES stop(id)
);


CREATE TABLE driver (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    psw VARCHAR(255) NOT NULL
);


CREATE TABLE admin (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    psw VARCHAR(255) NOT NULL
);
