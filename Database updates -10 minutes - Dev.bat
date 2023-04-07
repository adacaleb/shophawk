:: Last 10 minute exports for runlist
:: runlist ops
sqlcmd -S GEARSERVER\SQLEXPRESS -d PRODUCTION -E -Q "SELECT [Job] ,[Job_Operation] ,[WC_Vendor] ,[Operation_Service] ,[Vendor] ,[Sched_Start] ,[Sched_End] ,[Sequence], [Status] ,[Est_Total_Hrs] FROM [PRODUCTION].[dbo].[Job_Operation] WHERE Last_Updated > DATEADD(MINUTE,-10,GETDATE()) ORDER BY Job_Operation ASC" -o "C:\railsapps\shophawkdev\app\assets\csv\runListOps.csv" -W -w 1024 -s "`"
::tempjobs
sqlcmd -S GEARSERVER\SQLEXPRESS -d PRODUCTION -E -Q "SELECT [Job] ,[Customer] ,[Order_Date] ,[Part_Number] ,[Rev] ,[Description] ,[Order_Quantity] ,[Extra_Quantity] ,[Pick_Quantity] ,[Make_Quantity] ,[Open_Operations] ,[Completed_Quantity] ,[Shipped_Quantity] ,[FG_Transfer_Qty] ,[In_Production_Quantity] ,[Certs_Required] ,[Act_Scrap_Quantity] ,[Customer_PO] ,[Customer_PO_LN] ,[Sched_End] ,[Sched_Start] ,REPLACE (CONVERT(VARCHAR(MAX), Note_Text),CHAR(13)+CHAR(10),' ') ,[Released_Date] ,[User_Values] FROM [PRODUCTION].[dbo].[Job] WHERE Last_Updated > DATEADD(MINUTE,-10,GETDATE()) ORDER BY Job DESC" -o "C:\railsapps\shophawkdev\app\assets\csv\tempjobs.csv" -W -w 1024 -s "`"
::tempmats
sqlcmd -S GEARSERVER\SQLEXPRESS -d PRODUCTION -E -Q "SELECT [Job] ,[Material] ,[Vendor] ,[Description] ,[Pick_Buy_Indicator] ,[Status] FROM [PRODUCTION].[dbo].[Material_Req] WHERE Last_Updated > DATEADD(MINUTE,-10,GETDATE()) ORDER BY Job DESC" -o "C:\railsapps\shophawkdev\app\assets\csv\tempmat.csv" -W -w 1024 -s "`"
::uservalues
sqlcmd -S GEARSERVER\SQLEXPRESS -d PRODUCTION -E -Q "SELECT [User_Values] ,[Text1] FROM [PRODUCTION].[dbo].[User_Values] WHERE Text1 IS NOT NULL AND Last_Updated > DATEADD(MINUTE,-10,GETDATE())" -o "C:\railsapps\shophawkdev\app\assets\csv\userValues.csv" -W -w 1024 -s "`"

::yearly exports for runlist
::yearlyRunlist ops
sqlcmd -S GEARSERVER\SQLEXPRESS -d PRODUCTION -E -Q "SELECT [Job] ,[Job_Operation] ,[WC_Vendor] ,[Operation_Service] ,[Vendor] ,[Sched_Start] ,[Sched_End] ,[Sequence], [Status] ,[Est_Total_Hrs] FROM [PRODUCTION].[dbo].[Job_Operation] WHERE Sched_Start > DATEADD(month,-1,GETDATE()) ORDER BY Job DESC, Sequence" -o "C:\railsapps\shophawkdev\app\assets\csv\yearlyRunListOps.csv" -W -w 1024 -s "`"
::yearlyjobs
sqlcmd -S GEARSERVER\SQLEXPRESS -d PRODUCTION -E -Q "SELECT [Job] ,[Customer] ,[Order_Date] ,[Part_Number] ,[Rev] ,[Description] ,[Order_Quantity] ,[Extra_Quantity] ,[Pick_Quantity] ,[Make_Quantity] ,[Open_Operations] ,[Completed_Quantity] ,[Shipped_Quantity] ,[FG_Transfer_Qty] ,[In_Production_Quantity] ,[Certs_Required] ,[Act_Scrap_Quantity] ,[Customer_PO] ,[Customer_PO_LN] ,[Sched_End] ,[Sched_Start] , REPLACE (CONVERT(VARCHAR(MAX), Note_Text),CHAR(13)+CHAR(10),' ') ,[Released_Date] ,[User_Values] FROM [PRODUCTION].[dbo].[Job] WHERE Sched_Start > DATEADD(month,-1,GETDATE()) ORDER BY Job DESC" -o "C:\railsapps\shophawkdev\app\assets\csv\yearlyJobs.csv" -W -w 1024 -s "`"
::yearlymats
sqlcmd -S GEARSERVER\SQLEXPRESS -d PRODUCTION -E -Q "SELECT [Job] ,[Material] ,[Vendor] ,[Description] ,[Pick_Buy_Indicator] ,[Status] FROM [PRODUCTION].[dbo].[Material_Req] WHERE Due_Date > DATEADD(month,-1,GETDATE()) ORDER BY Job DESC" -o "C:\railsapps\shophawkdev\app\assets\csv\yearlyMat.csv" -W -w 1024 -s "`"
::yearlyuservalues
sqlcmd -S GEARSERVER\SQLEXPRESS -d PRODUCTION -E -Q "SELECT [User_Values] ,[Text1] FROM [PRODUCTION].[dbo].[User_Values] WHERE Text1 IS NOT NULL AND Last_Updated > DATEADD(month,-1,GETDATE())" -o "C:\railsapps\shophawkdev\app\assets\csv\yearlyUserValues.csv" -W -w 1024 -s "`"

::bankstatement history
sqlcmd -S GEARSERVER\SQLEXPRESS -d PRODUCTION -E -Q "SELECT [Statement_Date] ,[Beginning_Balance] ,[Ending_Balance] ,[Account_Ending_Bal] ,[Outstanding_Checks] ,[Cleared_Deposits] ,[Cleared_Checks] ,[Last_Updated] FROM [PRODUCTION].[dbo].[Bank_History] WHERE Last_Updated > DATEADD(month,-12,GETDATE()) ORDER BY Last_Updated DESC" -o "C:\railsapps\shophawkdev\app\assets\csv\bankhistory.csv" -W -w 1024 -s "`"
::Checkbook spending 
sqlcmd -S GEARSERVER\SQLEXPRESS -d PRODUCTION -E -Q "SELECT [Check_Number] ,[Vendor] ,[Bank] ,[Check_Date] ,[Check_Amt] ,[Discount_Amt] ,[Last_Updated] FROM [PRODUCTION].[dbo].[AP_Check] WHERE Status = 'Open' AND Last_Updated > DATEADD(month,-2,GETDATE()) ORDER BY Check_Date DESC" -o "C:\railsapps\shophawkdev\app\assets\csv\checkbookPayments.csv" -W -w 1024 -s "`"
:: deposits
sqlcmd -S GEARSERVER\SQLEXPRESS -d PRODUCTION -E -Q "SELECT TOP (1000) [Bank] ,[Status] ,[Deposit_Date] ,[Base_Amount] ,[Last_Updated] FROM [PRODUCTION].[dbo].[Deposit] WHERE Last_Updated > DATEADD(month,-2,GETDATE()) ORDER BY Deposit_Date DESC" -o "C:\railsapps\shophawkdev\app\assets\csv\deposits.csv" -W -w 1024 -s "`"