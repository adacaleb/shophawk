sqlcmd -S GEARSERVER\SQLEXPRESS -d PRODUCTION -E -Q "SELECT [Job] ,[Job_Operation] ,[WC_Vendor] ,[Operation_Service] ,[Vendor] ,[Sched_Start] ,[Sched_End] ,[Sequence], [Status] ,[Est_Total_Hrs] FROM [PRODUCTION].[dbo].[Job_Operation] WHERE Last_Updated > DATEADD(MINUTE,-10,GETDATE()) ORDER BY Job_Operation ASC" -o "C:\railsapps\shophawkdev\app\assets\csv\runListOps.csv" -W -w 1024 -s "`"

sqlcmd -S GEARSERVER\SQLEXPRESS -d PRODUCTION -E -Q "SELECT [Job] ,[Customer] ,[Order_Date] ,[Part_Number] ,[Rev] ,[Description] ,[Order_Quantity] ,[Extra_Quantity] ,[Pick_Quantity] ,[Make_Quantity] ,[Open_Operations] ,[Completed_Quantity] ,[Shipped_Quantity] ,[FG_Transfer_Qty] ,[In_Production_Quantity] ,[Certs_Required] ,[Act_Scrap_Quantity] ,[Customer_PO] ,[Customer_PO_LN] ,[Sched_End] ,[Sched_Start] ,[Note_Text] ,[Released_Date] FROM [PRODUCTION].[dbo].[Job] WHERE Last_Updated > DATEADD(MINUTE,-10,GETDATE()) ORDER BY Job DESC" -o "C:\railsapps\shophawkdev\app\assets\csv\tempjobs.csv" -W -w 1024 -s "`"

sqlcmd -S GEARSERVER\SQLEXPRESS -d PRODUCTION -E -Q "SELECT [Job] ,[Material] ,[Vendor] ,[Description] ,[Pick_Buy_Indicator] ,[Status] FROM [PRODUCTION].[dbo].[Material_Req] WHERE Last_Updated > DATEADD(MINUTE,-10,GETDATE()) ORDER BY Job DESC" -o "C:\railsapps\shophawkdev\app\assets\csv\tempmat.csv" -W -w 1024 -s "`"

