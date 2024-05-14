-- Create or alter the trigger
CREATE OR ALTER TRIGGER PreventCustomerDelete
ON Customers
 INSTEAD OF DELETE
AS
BEGIN
    -- Check if there are any associated orders
    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN Orders o ON d.CustomerID = o.CustomerID
    )
    BEGIN
        -- Rollback the delete operation and display an error message
        RAISERROR('Cannot delete customer with associated orders.', 16, 1)
        ROLLBACK TRANSACTION
    END
END
