# Data analytics power BI report

## Project Brief  
An industry project, simulating the work of a data analysts working for a medium-sized international retailer who is keen on elevating their business intelligence practices. With operations spanning across different regions, they've accumulated large amounts of sales from disparate sources over the years.  Recognizing the value of this data, they aim to transform it into actionable insights for better decision-making. Your goal is to use Microsoft Power BI to design a comprehensive Quarterly report. This will involve extracting and transforming data from various origins, designing a robust data model rooted in a star-based schema, and then constructing a multi-page report.  The report will present a high-level business summary tailored for C-suite executives, and also give insights into their highest value customers segmented by sales region, provide a detailed analysis of top-performing products categorised by type against their sales targets, and a visually appealing map visual that spotlights the performance metrics of their retail outlets across different territories.

## Loading data sources  
### Loading from Azure SQL database  
To load data from an Azure SQL database, the 'Get data' button on the home tab of the ribbon. After selecting the Azure SQL database option, enter the target server name, username and password. Then selecting and loading the necessary data.

### Loading data from a csv file  
Using the 'Get data' button on the home tab of the ribbon, select the Text/CSV option. In the file explorer select the file wanted to load in.

### Loading data from Azure blob storage  
Using the 'Get data' button on the home tab of the ribbon, select the Azure Blob Storage option. Enter the account name followed by the account key and select the desired container.

### Loading data from a zip file  
Firstly unzip the folder containg the csv files, then use the 'Get data' button on the home tab of the ribbon to open the Folder data connector and select 'Combine and Transform' to import the data.

## Creating the date table  
Using DAX I created a date table that will help with time intelligence later on. Each field in the table is as follows  
- `Day Of Week = WEEKDAY('Date'[Order Date]+1)`
- Month Name = FORMAT(DATE(1, 'Date'[Month Number], 1),"mmm")
- Month Number = MONTH('Date'[Order Date])
- Date = DATESBETWEEN(Orders[Order Date], MIN(Orders[Order Date]), DATE(2023,12,31))
- Quarter = QUARTER('Date'[Order Date])
- Start Of Month = STARTOFMONTH('Date'[Order Date])
- Start Of Quarter = STARTOFQUARTER('Date'[Order Date])
- Start Of Week = 'Date'[Order Date] - WEEKDAY('Date'[Order Date],2) + 1
- Start Of Year = STARTOFYEAR('Date'[Order Date])
- Year = YEAR('Date'[Order Date])

## Creating the data model  
### Building the star schema data model  
In the power BI model view I created relationships by dragging fields in one table to another table with a related field, the relationships are as follows  
- Orders[product_code] to Products[product_code]
- Orders[Store Code] to Stores[store code]
- Orders[User ID] to Customers[User UUID]
- Orders[Order Date] to Date[date]
- Orders[Shipping Date] to Date[date]

## Creating a measures table  
Now that the tables are linked I can create measures that can be used to build visuals. The measures in this table are as follow
- Current Q Order Target = [Previous Quarter Orders] * 1.1
- Current Q Profit Target = [Previous Quarter Profit] * 1.1
- Current Q Revenue Target = [Previous Quarter Revenue] * 1.1
- Current Quarter Orders = VAR CurrentQuarterStart = MAX('Date'[Start Of Quarter]) RETURN CALCULATE([Total Orders], 'Date'[Start Of Quarter] = CurrentQuarterStart && TODAY())
- Current Quarter Profit = VAR CurrentQuarterStart = MAX('Date'[Start Of Quarter]) RETURN CALCULATE([Total Profit], 'Date'[Start Of Quarter] = CurrentQuarterStart && TODAY())
- Current Quarter Revenue = VAR CurrentQuarterStart = MAX('Date'[Start Of Quarter]) RETURN CALCULATE([Total Revenue], 'Date'[Start Of Quarter] = CurrentQuarterStart && TODAY())
- Last YTD Profit = CALCULATE(SUMX( Orders, (RELATED(Products[Sale Price]) - RELATED(Products[Cost Price])) * Orders[Product Quantity]), DATESYTD(DATEADD('Date'[Order Date],-1,YEAR)))
- Last YTD Revenue = CALCULATE(SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale Price])), DATESYTD(DATEADD('Date'[Order Date],-1,YEAR)))
- Most Orders = MAXX (TOPN (1, VALUES ( Customers[Full Name] ), CALCULATE ( SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale Price])) ), DESC), [Total Orders])
- Orders Target = [Previous Quarter Orders] * 1.05
- Previous Quarter Orders = VAR CurrentQuarterStart = MAX('Date'[Start Of Quarter]) VAR PreviousQuarterStart = EDATE(CurrentQuarterStart, -3) VAR PreviousQuarterEnd = EDATE(CurrentQuarterStart, -1) RETURN CALCULATE([Total Orders], 'Date'[Start Of Quarter] = PreviousQuarterStart)
- Previous Quarter Profit = VAR CurrentQuarterStart = MAX('Date'[Start Of Quarter]) VAR PreviousQuarterStart = EDATE(CurrentQuarterStart, -3) VAR PreviousQuarterEnd = EDATE(CurrentQuarterStart, -1) RETURN CALCULATE([Total Profit], 'Date'[Start Of Quarter] = PreviousQuarterStart)
- Previous Quarter Revenue = VAR CurrentQuarterStart = MAX('Date'[Start Of Quarter]) VAR PreviousQuarterStart = EDATE(CurrentQuarterStart, -3) VAR PreviousQuarterEnd = EDATE(CurrentQuarterStart, -1) RETURN CALCULATE([Total Revenue], 'Date'[Start Of Quarter] = PreviousQuarterStart)
- Profit per Order = [Total Profit] / [Total Orders]
- Profit Target = [Previous Quarter Profit] * 1.05
- Profit YTD = TOTALYTD(SUMX(Orders, (RELATED(Products[Sale Price]) - RELATED(Products[Cost Price])) * Orders[Product Quantity]), 'Date'[Order Date])
- Revenue per Customer = [Total Revenue]/[Total Customers]
- Revenue Target = [Previous Quarter Revenue] * 1.05
- Revenue YTD = TOTALYTD(SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale Price])), 'Date'[Order Date])
- Target Profit YTD = [Last YTD Profit]*1.2
- Target Revenue YTD = [Last YTD Revenue] * 1.2
- Top Customer = MAXX (TOPN (1, VALUES ( Customers[Full Name] ), CALCULATE ( SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale Price])) ), DESC), Customers[Full Name])
- Top Revenue = MAXX (TOPN (1, VALUES ( Customers[Full Name] ), CALCULATE ( SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale Price])) ), DESC), [Total Revenue])
- Total Customers = DISTINCTCOUNT(Orders[User ID])
- Total Orders = COUNT(Orders[Order Date])
- Total Profit = SUMX( Orders, (RELATED(Products[Sale Price]) - RELATED(Products[Cost Price])) * Orders[Product Quantity])
- Total Quantity = SUM(Orders[Product Quantity])
- Total Revenue = SUMX(Orders, Orders[Product Quantity] * RELATED(Products[Sale Price]))

## Creating the reports  
### Executive Summary  
![image](https://github.com/PipWhite/data-analytics-power-bi-report875/assets/74298321/8c4003a3-ec68-4ae3-9c0b-65b64c02efa0)  
Total Revenue is a card which takes the measure Total Revenue as its field.  
Total Orders is a card which takes the measure Total Revenue as its field.  
Total Revenue is a card which takes the measure Total Revenue as its field. 
Total Revenue by Month is a line chart that takes Start of Month from the date hierachy on the X-axis and the measure Total Revenue on the Y-axis. 
Total Orders by Category is a clustered column chart that takes Category on the X-axis and the measure Total Orders on the Y-axis.  
Top Revenue by Country is a donut chart that takes Country as it legend and the measure Top Revenue as its values.  
Total Revenue by Store Type is a donut chart that takes Store Type as its legend and the measure Total Revenue as its values.  
Quarterly Revenue Target is a KPI that takes the measure Total Revenue as the value, the measure Revenue Target as the Target and Start Of Quarter as the trend axis.  
Quarterly Profit Target is a KPI that takes the measure Total Profit as the value, the measure Profit Target as the target and Start Of Quarter as the trend axis.
Quarterly Orders Target is a KPI that takes the measure Total Orders as the value, the measure Orders Target as the target and Start Of Quarter as the trend axis.

### Customer Detail  
![image](https://github.com/PipWhite/data-analytics-power-bi-report875/assets/74298321/b2da67d0-cfac-49dd-afbf-1637588068a0)  
Unique Customers is a card that takes the measure Total Customers as its field.  
Revenue per Customer is a card that take the measure Revenue per Customer as its field.  
Total Customers by Country is a donut chart that takes Country as its legend and the measure Total Customers as its values.  
Total Customers by Category is a clustered column chart that takes Category on the X-axis and the measure Total Customers on the Y-axis.  
Total Customers by Month is a line graph that takes Start Of Month from the date hierachy on the X-axis and the measure Total Customers on the Y-axis.  
The table on this page takes Full Name, the measure Total Revenue and the measure Total Orders as its columns. It is limited to the top 20 entries based on the measure Total Revenue.  
The Top Customer card displays the top customer from the table.  
The Top Revenue card displays the highest revenue from the table.  
The Most Orders card displays the highest number of order from the table.  
The Start Of Year slider takes Start Of Year from the date hierachy as its field.

### Product Detail  
![image](https://github.com/PipWhite/data-analytics-power-bi-report875/assets/74298321/318b7848-fce5-4934-8129-b36e911aa5ca)  
Sum of Profit per Item and Quantity by Description and Category is a scatter chart that takes Description as its value, sum of the measure Profit per Item as its X-axis, the measure Total Quantity as it Y- axis and Category as its legend.  
Current Quarter Orders Target is a guage that takes the measure Current Quarter Orders as its value and the measure Current Q Order Target as its maximum value.  
Current Quarter Profit Target is a guage that takes the measure Current Profit Orders as its value and the measure Current Q Profit Target as its maximum value.  
Current Quarter Revenue Target is a guage that takes the measure Current Quarter Revenue as its value and the measure Current Q Revenue Target as its maximum value.  
The table on this page takes the product Description, the measure Profit per Order, the measure Total Revenue, the measure Total Customers, the measure Total Orders as its columns. It is limited to the top 10 entries based on the Profit per Order measure.  
Total Revenue by Quarter and Category is an area chart that takes Start Of Quarter from the date hierachy on the X-axis, the measure Total Revenue on the Y-axis and Category as the legend.  

### Stores Map  
![image](https://github.com/PipWhite/data-analytics-power-bi-report875/assets/74298321/255351c5-23c7-4acf-9b99-4919060e376a)  
The slicer on this page takes the stores country as its field.  
Profit YTD by Geography is a map that takes Geography as its location, the measure Profit YTD as the bubble size and uses the Tooltip page as a tooltip.  

### Stores Drillthrough  
![image](https://github.com/PipWhite/data-analytics-power-bi-report875/assets/74298321/1e103dfe-6e5e-46e2-8988-bbb64fd8777f)  
This is a drillthrough page displayed after selecting a store from the Stores Map.  
The First Geography card displays the Geography of the selected store.  
Total Orders by Category takes Category on the X-axis and the measure Total Orders based on the selected store.  
Target Profit YTD is a guage that takes the measure Profit YTD as the value and the measure Target Profit YTD as the target value.  
Target Revenue YTD is a guage that takes the measure Revenue YTD as the value and the measure Target Revenue YTD as the target value.  
The table on this page takes the product Description, the measure Profit YTD, the measure Total Orders and the measure Total Revenue.  

### Tooltip Page  
![image](https://github.com/PipWhite/data-analytics-power-bi-report875/assets/74298321/12c484b7-1bd1-4d60-88f3-93c177eb73d3)  
When a user hovers over a store bubble on the Stores Map they are shown the tooltip page.  
Target Profit YTD uses the measure Profit YTD as the value and the measure Target Profit YTD as the target value.  
The Geography card shows the slecect store geography. 




















