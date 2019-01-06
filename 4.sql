DROP TABLE CONTRACT CASCADE CONSTRAINTS; 
DROP TABLE TASK CASCADE CONSTRAINTS; 

CREATE TABLE TASK (TaskID CHAR(3),TaskName VARCHAR(20),ContractCount NUMERIC(1,0) DEFAULT 0, 
CONSTRAINT PK_TASK PRIMARY KEY (TaskID));

CREATE TABLE CONTRACT (TaskID CHAR(3),WorkerID CHAR(7),Payment NUMERIC(6,2),
CONSTRAINT PK_CONTRACT PRIMARY KEY (TaskID, WorkerID),
CONSTRAINT FK_CONTRACTTASK FOREIGN KEY (TaskID) REFERENCES TASK (TaskID) );

INSERT INTO TASK (TaskID, TaskName) VALUES ('333', 'Security' );
INSERT INTO TASK (TaskID, TaskName) VALUES ('322','Infrastructure');
INSERT INTO TASK (TaskID, TaskName) VALUES ('896', 'Compliance' );

SELECT * FROM TASK;
COMMIT; 



REFERENCING new as new_value
for each row

declare
 contract_count NUMBER;

begin   
    select ContractCount into contract_count 
    from TASK where TaskID =: new_value.TaskID;
        if contract_count < 3 THEN
            update TASK set ContractCount = ContractCount+1 where TaskID =: new_value.TaskID;
        else RAISE_APPLICATION_ERROR(-20000,'The task is full.');
    end if;
 
END NewContract; 

create or replace trigger EndContract 
after delete on CONTRACT 

referencing old as old_value

for each row

declare
 contractct number;
begin

    select ContractCount INTO contractct 
    from TASK where TaskID =: old_value.TaskID;

        if contractct > 0 then
         update TASK set ContractCount = ContractCount - 1 where TaskID =: old_value.TaskID;
        else RAISE_APPLICATION_ERROR(-20001,'Error: the ContractCount is zero.');
        end if;
     end EndContract; 


create or replace trigger NoChanges 
before update on CONTRACT 
begin   
    if UPDATING then
        RAISE_APPLICATION_ERROR(-20002, 'No updates are permitted to existing rows of CONTRACT.'); 
end NoChanges; 

INSERT INTO Contract VALUES('111', '222', 333.0);
DELETE FROM Contract WHERE TaskID = 333;
UPDATE Contract SET TaskName = 'Test' WHERE TaskID = 333;