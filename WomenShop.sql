Drop database if exists WomenShop;
Create database WomenShop;
use WomenShop;

CREATE TABLE Users(
Id_client  INT NOT NULL AUTO_INCREMENT,
Firstname varchar(20),
Lastname varchar(20),
Email varchar(30) not null,
Password varchar(30) not null,
Admin boolean,
primary key(Id_client)
);

CREATE TABLE Products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    purchase_price DOUBLE NOT NULL CHECK (purchase_price > 0),
    sell_price DOUBLE NOT NULL CHECK (sell_price > 0),
    discount_price DOUBLE DEFAULT 0,
    nb_items INT DEFAULT 0 CHECK (nb_items >= 0)
);

CREATE TABLE Clothes (
    id INT PRIMARY KEY,  
    size INT NOT NULL CHECK (size BETWEEN 34 AND 54 AND size % 2 = 0), 
    FOREIGN KEY (id) REFERENCES Products(id) ON DELETE CASCADE
);

CREATE TABLE Shoes (
    id INT PRIMARY KEY,  
    shoe_size INT NOT NULL CHECK (shoe_size BETWEEN 36 AND 50), 
    FOREIGN KEY (id) REFERENCES Products(id) ON DELETE CASCADE
);

CREATE TABLE Accessories (
    id INT PRIMARY KEY, 
    FOREIGN KEY (id) REFERENCES Products(id) ON DELETE CASCADE
);

CREATE TABLE Orders(
Id_order INT NOT NULL auto_increment,
Id_client INT not null,
Status varchar(20),
DateBegin datetime,
DateEnd datetime,
Amount double,
primary key (Id_order),
foreign key (Id_client) references Users(Id_client)
);

CREATE TABLE Purchase(
Id_order INT NOT NULL,
Id_product INT NOT NULL,
nb_items INT NOT NULL CHECK (nb_items > 0),
FOREIGN KEY (Id_product) REFERENCES Products(id)
);

INSERT INTO Users VALUES(null, 'Admin', null, 'paul.escalier@edu.devinci.fr', 'admin', true);
INSERT INTO Users VALUES(null, 'UserTest', null, 'test@mail', 'test', false);

-- Insertion de produits dans la table Products
INSERT INTO Products (name, purchase_price, sell_price, discount_price, nb_items)
VALUES ('Robe Rouge', 30.00, 50.00, 45.00, 10),
       ('T-shirt Blanc', 10.00, 20.00, 0, 50),
       ('Baskets Running', 40.00, 70.00, 60.00, 15),
       ('Ceinture Cuir', 15.00, 25.00, 0, 30),
       ('Sac à Main Cuir', 50.00, 90.00, 80.00, 5);

-- Insertion de vêtements dans la table Clothes
INSERT INTO Clothes (id, size)
VALUES (1, 38),  -- Robe Rouge
       (2, 42);  -- T-shirt Blanc

-- Insertion de chaussures dans la table Shoes
INSERT INTO Shoes (id, shoe_size)
VALUES (3, 42);  -- Baskets Running

-- Insertion d'accessoires dans la table Accessories
INSERT INTO Accessories (id)
VALUES (4),  -- Ceinture Cuir
       (5);  -- Sac à Main Cuir

-- Insertion de commandes dans la table Orders
INSERT INTO Orders (Id_client, Status, DateBegin, DateEnd, Amount)
VALUES 
    -- Commande 1 : UserTest, en cours, montant calculé
    (2, 'in_progress', NOW(), NULL, 105.00), -- 1x Robe Rouge (45€) + 3x T-shirt Blanc (3 * 20€)

    -- Commande 2 : Admin, complète, montant calculé
    (1, 'complete', NOW(), NOW(), 45.00), -- 1x Robe Rouge (45€)

    -- Commande 3 : UserTest, expédiée, montant calculé
    (2, 'shipped', NOW(), NULL, 110.00); -- 1x Baskets Running (60€) + 2x Ceinture Cuir (2 * 25€)

-- Insertion des achats dans la table Purchase
INSERT INTO Purchase (Id_order, Id_product, nb_items)
VALUES 
    -- Pour la commande 1 (UserTest)
    (1, 1, 1),   -- 1x Robe Rouge (prix solde 45€)
    (1, 2, 3),   -- 3x T-shirt Blanc (prix normal 20€)

    -- Pour la commande 2 (Admin)
    (2, 1, 1),   -- 1x Robe Rouge (prix solde 45€)

    -- Pour la commande 3 (UserTest)
    (3, 3, 1),   -- 1x Baskets Running (prix solde 60€)
    (3, 4, 2);   -- 2x Ceinture Cuir (prix normal 25€)



select * from users;
select * from shoes;
select * from Products;
select * from clothes;
select * from Orders;
select * from purchase;
SELECT p.id, p.Name, pu.nb_items, p.Sell_price, p.discount_price FROM Products p JOIN Purchase pu ON p.id = pu.Id_product WHERE pu.id_order = 2;
SELECT SUM(Amount) AS TotalIncome FROM Orders;
SELECT SUM(purchase_price * nb_items) AS TotalCost FROM Products;
