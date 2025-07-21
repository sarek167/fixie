CREATE TRIGGER trg_UpdateTasksTimestamp
ON tasks
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE tasks
    SET updated_at = GETDATE()
    FROM tasks t
    INNER JOIN inserted i ON t.id = i.id;
END;
GO


CREATE TRIGGER trg_UpdatePathsTimestamp
ON paths
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE paths
    SET updated_at = GETDATE()
    FROM paths p
    INNER JOIN inserted i ON p.id = i.id;
END;
GO


CREATE TRIGGER trg_UpdateUserPathsTimestamp
ON user_paths
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE user_paths
    SET updated_at = GETDATE()
    FROM user_paths up
    INNER JOIN inserted i ON up.id = i.id;
END;
GO
