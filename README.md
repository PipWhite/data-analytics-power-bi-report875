# Data analytics power BI report

## Project Brief  
An industry project simulating the work of a data analysts working for a medium-sized international retailer who is keen on elevating their business intelligence practices. With operations spanning across different regions, they've accumulated large amounts of sales from disparate sources over the years.  Recognizing the value of this data, they aim to transform it into actionable insights for better decision-making. Your goal is to use Microsoft Power BI to design a comprehensive Quarterly report. This will involve extracting and transforming data from various origins, designing a robust data model rooted in a star-based schema, and then constructing a multi-page report.  The report will present a high-level business summary tailored for C-suite executives, and also give insights into their highest value customers segmented by sales region, provide a detailed analysis of top-performing products categorised by type against their sales targets, and a visually appealing map visual that spotlights the performance metrics of their retail outlets across different territories.

## Loading data sources  
### Loading from Azure SQL database  
To load data from an Azure SQL database, the 'Get data' button on the home tab of the ribbon. After selecting the Azure SQL database option, enter the target server name, username and password. Then selecting and loading the necessary data.

### Loading data from a csv file  
Using the 'Get data' button on the home tab of the ribbon, select the Text/CSV option. In the file explorer select the file wanted to load in.

### Loading data from Azure blob storage  
Using the 'Get data' button on the home tab of the ribbon, select the Azure Blob Storage option. Enter the account name followed by the account key and select the desired container.

### Loading data from a zip file  
Firstly unzip the folder containg the csv files, then use the 'Get data' button on the home tab of the ribbon to open the Folder data connector and select 'Combine and Transform' to import the data.

## Creating the data model  
### Creating the date table  
Using DAX I created a date table that will help with time intelligence later on. Each field in the table is as follows  
- Day Of Week = WEEKDAY('Date'[Order Date]+1)
- Month Name = FORMAT(DATE(1, 'Date'[Month Number], 1),"mmm")
- Month Number = MONTH('Date'[Order Date])
- Date = DATESBETWEEN(Orders[Order Date], MIN(Orders[Order Date]), DATE(2023,12,31))
- Quarter = QUARTER('Date'[Order Date])
- Start Of Month = STARTOFMONTH('Date'[Order Date])
- Start Of Quarter = STARTOFQUARTER('Date'[Order Date])
- Start Of Week = 'Date'[Order Date] - WEEKDAY('Date'[Order Date],2) + 1
- Start Of Year = STARTOFYEAR('Date'[Order Date])
- Year = YEAR('Date'[Order Date])

### Building the star schema data model  
In the power BI model view I created relationships by dragging fields in one table to another table with a related field, the relationships are as follows  
- Orders[product_code] to Products[product_code]
- Orders[Store Code] to Stores[store code]
- Orders[User ID] to Customers[User UUID]
- Orders[Order Date] to Date[date]
- Orders[Shipping Date] to Date[date]
  
