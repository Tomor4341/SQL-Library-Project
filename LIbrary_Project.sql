

CREATE SCHEMA `Sql-Library-Project`;
USE `Sql-Project`;

DROP TABLE IF EXISTS Borrowedby, Holding, Authoredby, Author, Book, Publisher, Member, Branch;

/*Table structure for table `branch` */
CREATE TABLE Branch (
  BranchID INT NOT NULL, 
  BranchSuburb varchar(255) NOT NULL,
  BranchState char(3) NOT NULL,
  PRIMARY KEY (BranchID)
);

CREATE TABLE Member (
  MemberID INT NOT NULL, 
  MemberStatus char(9) DEFAULT 'REGULAR',
  MemberName varchar(255) NOT NULL,
  MemberAddress varchar(255) NOT NULL,
  MemberSuburb varchar(25) NOT NULL,
  MemberState char(3) NOT NULL,
  MemberExpDate DATE,
  MemberPhone varchar(10),
  -- TASK 1: implemented Overdue Fees
  OverdueFees DECIMAL(10,2) DEFAULT 0,
  PRIMARY KEY (`MemberID`)
);

CREATE TABLE SuspensionRecord (
	SuspensionID INT NOT NULL AUTO_INCREMENT,
    MemberID INT NOT NULL,
    SuspensionDate DATETIME,
    PRIMARY KEY (SuspensionID),
    CONSTRAINT member_fk_2 FOREIGN KEY (MemberID) REFERENCES `Member` (MemberID)
);

CREATE TABLE Publisher (
  PublisherID INT NOT NULL, 
  PublisherName varchar(255) NOT NULL,
  PublisherAddress varchar(255) DEFAULT NULL,
  PRIMARY KEY (PublisherID)
);

CREATE TABLE Book (
  BookID INT NOT NULL,
  BookTitle varchar(255) NOT NULL,
  PublisherID INT NOT NULL,
  PublishedYear INT4,
  Price Numeric(5,2) NOT NULL,
  PRIMARY KEY (BookID),
  KEY PublisherID (PublisherID),
  CONSTRAINT publisher_fk_1 FOREIGN KEY (PublisherID) REFERENCES Publisher (PublisherID) ON DELETE RESTRICT
);

CREATE TABLE Author (
  AuthorID INT NOT NULL, 
  AuthorName varchar(255) NOT NULL,
  AuthorAddress varchar(255) NOT NULL,
  PRIMARY KEY (AuthorID)
);

CREATE TABLE Authoredby (
  BookID INT NOT NULL,
  AuthorID INT NOT NULL, 
  PRIMARY KEY (BookID,AuthorID),
  KEY BookID (BookID),
  KEY AuthorID (AuthorID),
  CONSTRAINT book_fk_1 FOREIGN KEY (BookID) REFERENCES Book (BookID) ON DELETE RESTRICT,
  CONSTRAINT author_fk_1 FOREIGN KEY (AuthorID) REFERENCES Author (AuthorID) ON DELETE RESTRICT
);

CREATE TABLE Holding (
  BranchID INT NOT NULL, 
  BookID INT NOT NULL,
  InStock INT DEFAULT 1,
  OnLoan INT DEFAULT 0,
  PRIMARY KEY (BranchID, BookID),
  KEY BookID (BookID),
  KEY BranchID (BranchID),
  CONSTRAINT holding_cc_1 CHECK(InStock>=OnLoan),
  CONSTRAINT book_fk_2 FOREIGN KEY (BookID) REFERENCES Book (BookID) ON DELETE RESTRICT,
  CONSTRAINT branch_fk_1 FOREIGN KEY (BranchID) REFERENCES Branch (BranchID) ON DELETE RESTRICT
);

CREATE TABLE Borrowedby (
  BookIssueID INT UNSIGNED NOT NULL AUTO_INCREMENT,
  BranchID INT NOT NULL,
  BookID INT NOT NULL,
  MemberID INT NOT NULL,
  DateBorrowed DATE,
  DateReturned DATE DEFAULT NULL,
  ReturnDueDate DATE,
  PRIMARY KEY (BookIssueID),
  KEY BookID (BookID),
  KEY BranchID (BranchID),
  KEY MemberID (MemberID),
  CONSTRAINT borrowedby_cc_1 CHECK(DateBorrowed<ReturnDueDate),
  CONSTRAINT holding_fk_1 FOREIGN KEY (BookID,BranchID) REFERENCES Holding (BookID,BranchID) ON DELETE RESTRICT,
  CONSTRAINT member_fk_1 FOREIGN KEY (MemberID) REFERENCES Member (MemberID) ON DELETE RESTRICT
) ;



DELETE FROM Author;
INSERT INTO Author (AuthorID,AuthorName,AuthorAddress ) 
VALUES ('1', 'Tolstoy','Russian Empire');
INSERT INTO Author (AuthorID,AuthorName,AuthorAddress ) 
VALUES ('2', 'Tolkien','England');
INSERT INTO Author (AuthorID,AuthorName,AuthorAddress ) 
VALUES ('3', 'Asimov','America');
INSERT INTO Author (AuthorID,AuthorName,AuthorAddress ) 
VALUES ('4', 'Silverberg','America');
INSERT INTO Author (AuthorID,AuthorName,AuthorAddress ) 
VALUES ('5', 'Paterson','Australia');

DELETE FROM Branch;
INSERT INTO Branch (BranchID,BranchSuburb,BranchState) 
VALUES ('1','Parramatta','NSW');
INSERT INTO Branch (BranchID,BranchSuburb,BranchState) 
VALUES ('2','North Ryde','NSW');
INSERT INTO Branch (BranchID,BranchSuburb,BranchState) 
VALUES ('3','Sydney City','NSW');

DELETE FROM Publisher;
INSERT INTO Publisher (PublisherID,PublisherName,PublisherAddress ) 
VALUES ('1','Penguin','New York');
INSERT INTO Publisher (PublisherID,PublisherName,PublisherAddress ) 
VALUES ('2','Platypus','Sydney');
INSERT INTO Publisher (PublisherID,PublisherName,PublisherAddress ) 
VALUES ('3','Another Choice','Patagonia');

-- TASK 1: Implemented data to OverdueFees
DELETE FROM Member;
INSERT INTO Member (MemberID,MemberStatus,MemberName,MemberAddress,MemberSuburb,MemberState,MemberExpDate,MemberPhone, OverdueFees) 
VALUES ('1','REGULAR','Joe','4 Nowhere St','Here','NSW','2021-09-30','0434567811', 30.00);
INSERT INTO Member (MemberID,MemberStatus,MemberName,MemberAddress,MemberSuburb,MemberState,MemberExpDate,MemberPhone, OverdueFees) 
VALUES ('2','REGULAR','Pablo','10 Somewhere St','There','ACT','2022-09-30','0412345678', 0);
INSERT INTO Member (MemberID,MemberStatus,MemberName,MemberAddress,MemberSuburb,MemberState,MemberExpDate,MemberPhone, OverdueFees) 
VALUES ('3','REGULAR','Chen','23/9 Faraway Cl','Far','QLD','2020-11-30','0412346578', 4.00);
INSERT INTO Member (MemberID,MemberStatus,MemberName,MemberAddress,MemberSuburb,MemberState,MemberExpDate,MemberPhone, OverdueFees) 
VALUES ('4','REGULAR','Zhang','Dunno St','North','NSW','2020-12-31','', 0);
INSERT INTO Member (MemberID,MemberStatus,MemberName,MemberAddress,MemberSuburb,MemberState,MemberExpDate,MemberPhone, OverdueFees) 
VALUES ('5','REGULAR','Saleem','44 Magnolia St','South','SA','2020-09-30','1234567811', 20.00);
INSERT INTO Member (MemberID,MemberStatus,MemberName,MemberAddress,MemberSuburb,MemberState,MemberExpDate,MemberPhone, OverdueFees) 
VALUES ('6','SUSPENDED','Homer','Middle of Nowhere','North Ryde','NSW','2020-09-30','1234555811', 16.00);

-- Implemented few other people into Member table to cover all possible cases
INSERT INTO Member (MemberID,MemberStatus,MemberName,MemberAddress,MemberSuburb,MemberState,MemberExpDate,MemberPhone, OverdueFees) 
VALUES ('7','SUSPENDED','Rick','2 Elm Street','Bikini Bottom','NSW','2020-01-30','432155811', 0);

INSERT INTO Member (MemberID,MemberStatus,MemberName,MemberAddress,MemberSuburb,MemberState,MemberExpDate,MemberPhone, OverdueFees) 
VALUES ('8','SUSPENDED','Tom','Back street','Byron Bay','NSW','2020-02-28','123229001', 14.00);

INSERT INTO Member (MemberID,MemberStatus,MemberName,MemberAddress,MemberSuburb,MemberState,MemberExpDate,MemberPhone, OverdueFees) 
VALUES ('9','SUSPENDED','Brian','First Road','Central','NSW','2020-11-30','433445811', 0);


DELETE FROM SuspensionRecord;
INSERT INTO SuspensionRecord (SuspensionID, MemberID, SuspensionDate)
VALUES ('1', '1', '2021-11-30');
INSERT INTO SuspensionRecord (SuspensionID, MemberID, SuspensionDate)
VALUES ('2', '1', '2022-12-10');
INSERT INTO SuspensionRecord (SuspensionID, MemberID, SuspensionDate)
VALUES ('3', '1', '2023-06-12');
INSERT INTO SuspensionRecord (SuspensionID, MemberID, SuspensionDate)
VALUES ('4', '2', '2021-05-11');
INSERT INTO SuspensionRecord (SuspensionID, MemberID, SuspensionDate)
VALUES ('5', '2', '2021-10-11');
INSERT INTO SuspensionRecord (SuspensionID, MemberID, SuspensionDate)
VALUES ('6', '3', '2011-01-21');
INSERT INTO SuspensionRecord (SuspensionID, MemberID, SuspensionDate)
VALUES ('7', '6', '2023-05-20');
INSERT INTO SuspensionRecord (SuspensionID, MemberID, SuspensionDate)
VALUES ('8', '6', '2022-05-20');


DELETE FROM Book;
INSERT INTO Book (BookID,BookTitle,PublisherID,PublishedYear,Price )
VALUES ('1','Anna Karenina','1','2003',12.75);
INSERT INTO Book (BookID,BookTitle,PublisherID,PublishedYear,Price )
VALUES ('2','War and Peace','2','1869',139.99);
INSERT INTO Book (BookID,BookTitle,PublisherID,PublishedYear,Price )
VALUES ('3','The Hobbit','2','1937',9.19);
INSERT INTO Book (BookID,BookTitle,PublisherID,PublishedYear,Price )
VALUES ('4','I, Robot','2','1950',29.99);
INSERT INTO Book (BookID,BookTitle,PublisherID,PublishedYear,Price )
VALUES ('5','The Positronic Man','3','2010',125.99);

DELETE FROM Authoredby;
INSERT INTO Authoredby (BookID,AuthorID) VALUES ('1', '1');
INSERT INTO Authoredby (BookID,AuthorID) VALUES ('2', '1');
INSERT INTO Authoredby (BookID,AuthorID) VALUES ('3', '2');
INSERT INTO Authoredby (BookID,AuthorID) VALUES ('4', '3');
INSERT INTO Authoredby (BookID,AuthorID) VALUES ('5', '3');
INSERT INTO Authoredby (BookID,AuthorID) VALUES ('5', '4');

DELETE FROM Holding;
INSERT INTO Holding (BranchID,BookID,InStock,OnLoan) 
VALUES ('1', '1','2','2');
INSERT INTO Holding (BranchID,BookID,InStock,OnLoan) 
VALUES ('1', '2','2','1');
INSERT INTO Holding (BranchID,BookID,InStock,OnLoan) 
VALUES ('1', '3','3','1');
INSERT INTO Holding (BranchID,BookID,InStock,OnLoan) 
VALUES ('2', '1','1','1');
INSERT INTO Holding (BranchID,BookID,InStock,OnLoan) 
VALUES ('2', '4','3','2');
INSERT INTO Holding (BranchID,BookID,InStock,OnLoan) 
VALUES ('3', '4','4','0');
INSERT INTO Holding (BranchID,BookID,InStock,OnLoan) 
VALUES ('3', '5','2','1');

DELETE FROM Borrowedby;
INSERT INTO Borrowedby (BranchID,BookID,MemberID,DateBorrowed,DateReturned,ReturnDueDate)
VALUES ('1', '1','2',curdate(),NULL,date_add(curdate(),INTERVAL 3 WEEK));
INSERT INTO Borrowedby (BranchID,BookID,MemberID,DateBorrowed,DateReturned,ReturnDueDate)
VALUES ('2', '4','4',curdate(),NULL,date_add(curdate(),INTERVAL 3 WEEK));
INSERT INTO Borrowedby (BranchID,BookID,MemberID,DateBorrowed,DateReturned,ReturnDueDate)
VALUES ('2', '1','4',curdate(),NULL,date_add(curdate(),INTERVAL 3 WEEK));
INSERT INTO Borrowedby (BranchID,BookID,MemberID,DateBorrowed,DateReturned,ReturnDueDate)
VALUES ('2', '4','1',curdate(),NULL,date_add(curdate(),INTERVAL 3 WEEK));
INSERT INTO Borrowedby (BranchID,BookID,MemberID,DateBorrowed,DateReturned,ReturnDueDate)
VALUES ('3', '5','3',curdate(),NULL,date_add(curdate(),INTERVAL 3 WEEK));
INSERT INTO Borrowedby (BranchID,BookID,MemberID,DateBorrowed,DateReturned,ReturnDueDate)
VALUES ('1', '1','1','2020-08-30',NULL,'2020-09-30');
INSERT INTO Borrowedby (BranchID,BookID,MemberID,DateBorrowed,DateReturned,ReturnDueDate)
VALUES ('1', '2','2','2020-08-30',NULL,'2020-09-30');
INSERT INTO Borrowedby (BranchID,BookID,MemberID,DateBorrowed,DateReturned,ReturnDueDate)
VALUES ('3', '4','2','2020-08-30',NULL,'2020-09-30');
-- Implemented more rows into Borrowedby Table to cover all possible cases.
INSERT INTO Borrowedby (BranchID,BookID,MemberID,DateBorrowed,DateReturned,ReturnDueDate)
VALUES ('3', '4','8','2019-07-30',NULL,'2019-08-30');
INSERT INTO Borrowedby (BranchID,BookID,MemberID,DateBorrowed,DateReturned,ReturnDueDate)
VALUES ('3', '4','7','2019-08-30',NULL,'2019-09-30');

-- Task 1
SELECT MemberName, CONCAT('$', OverdueFees) as `Overdue Fees`
FROM `Member`

-- Task 2
DELIMITER //
/* Create trigger for BR8: Reset a member's status after the member 
has paid all outstanding fees and returned all items.*/

CREATE TRIGGER ResetMemberStatus
AFTER UPDATE ON `Member`
	FOR EACH ROW 
BEGIN
-- Declare a OverdueItemCount variable to check for overdue items for resetting of member status
	DECLARE OverdueItemCount INT;
    DECLARE msg VARCHAR(255);
    
	SELECT COUNT(*) into OverdueItemCount
	FROM BorrowedBy
	WHERE MemberID = NEW.MemberID
		AND DateReturned IS NULL
		AND ReturnDueDate < CURDATE();
    
    -- Verify update to MemberStatus from SUSPENDED to REGULAR
	IF NEW.MemberStatus = 'REGULAR' AND OLD.MemberStatus = 'SUSPENDED' THEN
		-- Verify that all fees have been paid and items returned
		IF NEW.OverdueFees = 0 AND OverdueItemCount = 0 THEN
			-- Proceed to update Member table with changes
			UPDATE `Member`
			SET MemberStatus = 'REGULAR'
			WHERE MemberID = NEW.MemberID;
		ELSE
		-- error handler for cases where member still has overduefees or items awaiting return
			SET msg = CONCAT('Cannot process member status reset: ',
                 'Outstanding fees: ', NEW.OverdueFees, '; ',
                 'Overdue items: ', OverdueItemCount);
            SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = msg;
		END IF;
	END IF;
END;
//
DELIMITER ;


-- Task 3 

DELIMITER //
DROP PROCEDURE IF EXISTS TerminateMembers //
CREATE PROCEDURE TerminateMembers()
BEGIN
	-- Error Handler to respond to any errors that occur
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'An error occurred while processing TerminateMembers' AS Error;
    END;
   
	-- Update MemberStatus to TERMINATE if Member matches termination criteria
	UPDATE Member
    SET MemberStatus = 'TERMINATE'
    WHERE MemberID IN (
		SELECT MemberID
        FROM (
			-- Check whether member has any current overdue items
			SELECT DISTINCT m.MemberID
			FROM Member m
			JOIN Borrowedby b ON m.MemberID = b.MemberID
			WHERE b.DateReturned IS NULL AND b.ReturnDueDate < CURDATE()
			AND 
            -- Check whether member has been suspended twice in the past 3 years
				(SELECT COUNT(*)
				FROM SuspensionRecord s
				WHERE s.MemberID = m.MemberID
				AND SuspensionDate >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR)) >= 2) As TerminateCriteria
                );
END; 
//
DELIMITER ;

-- Call procedure to test
CALL TerminateMembers();


-- Verify procedure my displaying Member tablee
SELECT * FROM Member;



