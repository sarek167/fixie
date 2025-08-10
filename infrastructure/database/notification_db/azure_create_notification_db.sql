USE notifications_db;
GO

CREATE TABLE notifications (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    payload NVARCHAR(MAX) NOT NULL,  -- Zastępstwo dla JSON
    delivered BIT NOT NULL,
    delivered_at DATETIME2,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
);
GO
