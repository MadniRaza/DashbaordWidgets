USE [cwdw]
GO
/****** Object:  Table [dbo].[IP_WidgetGroupCounts]    Script Date: 2/24/2019 10:45:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IP_WidgetGroupCounts](
	[WidgetGroupId] [int] NOT NULL,
	[WidgetId] [int] NOT NULL,
 CONSTRAINT [PK_IP_WidgetGroupCounts] PRIMARY KEY CLUSTERED 
(
	[WidgetGroupId] ASC,
	[WidgetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IP_Widgets]    Script Date: 2/24/2019 10:45:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IP_Widgets](
	[WidgetId] [int] NOT NULL,
	[Company] [varchar](50) NULL,
	[WidgetTitle] [varchar](30) NOT NULL,
	[WidgetTitleShort] [varchar](18) NULL,
	[WidgetDesc] [varchar](100) NOT NULL,
	[WidgetType] [varchar](15) NOT NULL,
	[WidgetMinSize] [varchar](3) NOT NULL,
	[WidgetMaxSize] [varchar](3) NOT NULL,
	[WidgetQuery] [nvarchar](max) NULL,
	[URL] [varchar](100) NULL,
	[ColumnFormat] [nvarchar](1000) NULL,
	[BackgroundColor] [nvarchar](100) NULL,
	[CountType] [varchar](4) NULL,
	[WidgetIcon] [varchar](30) NOT NULL,
	[InGroup] [bit] NOT NULL,
	[WidgetStatus] [bit] NOT NULL,
 CONSTRAINT [PK_Widget] PRIMARY KEY CLUSTERED 
(
	[WidgetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IP_WidgetsEmp]    Script Date: 2/24/2019 10:45:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IP_WidgetsEmp](
	[EmpId] [int] NOT NULL,
	[WidgetId] [int] NOT NULL,
	[WidgetPositionX] [int] NOT NULL,
	[WidgetPositionY] [int] NOT NULL,
	[WidgetSizeX] [int] NOT NULL,
	[WidgetSizeY] [int] NOT NULL,
 CONSTRAINT [PK_IP_WidgetsEmp] PRIMARY KEY CLUSTERED 
(
	[EmpId] ASC,
	[WidgetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[IP_WidgetGroupCounts] ([WidgetGroupId], [WidgetId]) VALUES (11, 7)
GO
INSERT [dbo].[IP_WidgetGroupCounts] ([WidgetGroupId], [WidgetId]) VALUES (11, 8)
GO
INSERT [dbo].[IP_WidgetGroupCounts] ([WidgetGroupId], [WidgetId]) VALUES (11, 9)
GO
INSERT [dbo].[IP_WidgetGroupCounts] ([WidgetGroupId], [WidgetId]) VALUES (11, 10)
GO
INSERT [dbo].[IP_WidgetGroupCounts] ([WidgetGroupId], [WidgetId]) VALUES (15, 16)
GO
INSERT [dbo].[IP_WidgetGroupCounts] ([WidgetGroupId], [WidgetId]) VALUES (15, 17)
GO
INSERT [dbo].[IP_WidgetGroupCounts] ([WidgetGroupId], [WidgetId]) VALUES (18, 19)
GO
INSERT [dbo].[IP_WidgetGroupCounts] ([WidgetGroupId], [WidgetId]) VALUES (18, 20)
GO
INSERT [dbo].[IP_WidgetGroupCounts] ([WidgetGroupId], [WidgetId]) VALUES (21, 22)
GO
INSERT [dbo].[IP_WidgetGroupCounts] ([WidgetGroupId], [WidgetId]) VALUES (21, 23)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (1, N'VT01', N'Received Not Inspected', N'Rcvd Not Insp.', N'Parts Received but not Inspected', N'count', N'1:2', N'1:2', N'SELECT        COUNT(*) 
FROM            Erp.RcvDtl AS RDL 
WHERE        (RDL.VendorNum <> 603) AND (RDL.InspectionReq = 1) AND (RDL.InspectionPending = 1) AND (RDL.Company = @Company)', N'\\RcvdNotInsp\\Index', NULL, N'bg-red', N'qty', N'fa-search-minus', 0, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (2, N'VT01', N'Open PO List (Last 30 Days)', N'Open POs', N'Open PO List for last 30 days', N'table', N'2:2', N'4:4', N'SELECT CAST(POR.PONum AS varchar) + ''-'' + CAST(POR.POLine AS varchar) + ''-'' + CAST(POR.PORelNum AS varchar) AS PO
	,POD.PartNum
	,POH.OrderDate
	,POR.DueDate
    ,(POR.RelQty - POR.ReceivedQty) AS OpenQty
FROM Erp.POHeader AS POH
INNER JOIN Erp.PODetail AS POD ON 
	POH.Company = POD.Company
	AND POH.PONum = POD.PONUM
INNER JOIN Erp.PORel AS POR ON 
	POD.Company = POR.Company
	AND POD.PONUM = POR.PONum
	AND POD.POLine = POR.POLine
WHERE (POR.Plant = @Plant)
    AND (POR.Company = @Company)
    AND (POR.VoidRelease = 0)
	AND (POD.VoidLine = 0)
	AND (POH.VoidOrder = 0)
	AND (POH.OpenOrder = 1) 
	AND (POR.OpenRelease = 1) 
	AND (POD.OpenLine = 1)
	AND POH.OrderDate >= dateadd(MONTH, -1, getdate()) AND POH.OrderDate <= getdate()

ORDER BY POR.PONum, POR.POLine', NULL, N'[{"title":"PO","className":"text-left","targets":[0]},{"title":"Part No.","className":"text-left","targets":[1]},{"title":"Order Dt.","className":"text-right","targets":[2]},{"title":"Due Dt.","className":"text-right","targets":[3]}, {"title":"Open Qty.","className":"text-right","targets":[4]}]', NULL, NULL, N'fa-table', 0, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (3, N'VT01', N'Excess On Hand Summary', N'Excess OH', N'Summarized Chart', N'chart', N'2:2', N'4:4', N'SELECT  ProdDesc x, XCS_OH_OVER_90, XCS_OH_OVER_ALL,
 XCS_OH_WITH_NO_DEMAND FROM Mrp.XCS_SMRY 
WHERE Company = @Company AND Plant  = @Plant', NULL, N'Over 90,Over All,No Demand', N'#1988C8,#EB9100,#FF4A2E', NULL, N'fa-chart-bar', 0, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (4, N'VT01', N'Recently Used', N'Recently Used', N'Most Recently Used Reports', N'hyperlist', N'1:2', N'3:3', N'SELECT TOP(10)        Y.MnuHyperlink AS URL, Y.MnuTitleShort AS Title
FROM            dbo.zLogMru AS X INNER JOIN
                         dbo.IP_Mnu AS Y ON Y.RptCode = X.RptCode
WHERE Y.MnuType IN (''epi'',''pix'',''con'') AND X.EmpId = @EmpId ORDER BY AccessCount DESC', NULL, NULL, NULL, NULL, N'fa-list', 0, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (5, N'VT01', N'List', N'List', N'this is a simple list', N'list', N'1:1', N'3:1', N'c', NULL, NULL, NULL, NULL, N'fa-list', 0, 0)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (6, N'VT01', N'Received Not Invoiced', N'Rcvd Not Inv.', N'Total Pack Lines received not invoiced', N'count', N'1:2', N'1:2', N'WITH invcqty AS (
		SELECT Company, VendorNum, PackSlip, Packline, sum(OurQty) AS OurInvcQty
		FROM Erp.APInvDtl
		GROUP BY Company, VendorNum, PackSlip, Packline
		)
SELECT COUNT(*)
FROM Erp.RcvDtl RD
LEFT JOIN invcqty ON RD.Company = invcqty.company
	AND RD.VendorNum = invcqty.VendorNum
	AND RD.PackSlip = invcqty.PackSlip
	AND RD.PackLine = invcqty.packline
WHERE (OurQty <> isnull(ourinvcqty, 0))
	AND (RD.ReceiptDate IS NOT NULL)
	AND RD.vendornum <> 603
	AND (RD.Company = @Company)', N'\\RcvdNotInvcd\\Index', NULL, N'bg-red', N'qty', N'fa-not-equal', 0, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (7, N'VT01', N'On Hand (With Demand)', N'On hand(demand)', N'Total Excess Cost of Parts with Demand', N'count', N'1:2', N'1:2', N'SELECT SUM(XCS_OH_OVER_ALL) FROM Mrp.XCS_SMRY
 WHERE       Company  = @Company', N'\\ExcessSMRY\\Index', N'', N'bg-green', N'cost', N'fa-calendar-plus', 1, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (8, N'VT01', N'On Hand (No Demand)', N'On hand(No demand)', N'Total Excess Cost of On Hand Parts with No Demand', N'count', N'1:2', N'1:2', N'SELECT SUM(XCS_OH_WITH_NO_DEMAND) FROM Mrp.XCS_SMRY WHERE       Company  = @Company', N'\\ExcessSMRY\\Index', N'', N'bg-red', N'cost', N'fa-calendar-plus', 1, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (9, N'VT01', N'On Order (With Demand)', N'On Order (Demand)', N'Total Excess Cost of Orders with Demand', N'count', N'1:2', N'1:2', N'SELECT SUM(XCS_OO_WITH_DEMAND) FROM Mrp.XCS_SMRY WHERE       Company  = @Company', N'\\ExcessSMRY\\Index', N'', N'bg-green', N'cost', N'fa-calendar-plus', 1, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (10, N'VT01', N'On Order (No Demand)', N'On Order(No Demnd)', N'Total Excess Cost of Orders with No Demand', N'count', N'1:2', N'1:2', N'SELECT SUM(XCS_OO_WITH_NO_DEMAND) FROM Mrp.XCS_SMRY WHERE       Company  = @Company', N'\\ExcessSMRY\\Index', N'', N'bg-red', N'cost', N'fa-calendar-plus', 1, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (11, N'VT01', N'Excess Summary', N'Exc. Summary', N'On Order (with demand & no demand), On Hand (with demand & no demand)', N'count_group', N'2:2', N'2:2', N' ', NULL, NULL, NULL, NULL, N'fa-dollar-sign', 0, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (14, N'LcdBuyer', N'Recently Used', N'Recently Used', N'Most Recently Used Reports', N'hyperlist', N'1:1', N'3:3', N'SELECT TOP(10)        Y.MnuHyperlink AS URL, Y.MnuTitleShort AS Title
FROM            dbo.zLogMru AS X INNER JOIN
                         dbo.IP_Mnu AS Y ON Y.RptCode = X.RptCode
WHERE Y.MnuType =''Lcd'' AND X.EmpId = @EmpId ORDER BY AccessCount DESC', NULL, NULL, NULL, NULL, N'fa-list', 0, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (15, N'LcdBuyer', N'Purchase Orders', N'PO', N'PO', N'count_group', N'1:2', N'1:2', N' ', NULL, NULL, NULL, NULL, N'fa-building', 0, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (16, N'LcdBuyer', N'New PO', N'New PO', N'New POs', N'count', N'1:2', N'1:2', N'SELECT COUNT(*)  FROM LcdBuyerDB.Lcd.POHeader   WHERE POStatus  = ''N''', N'\\Home\\Error?page=detailed', NULL, N'bg-red', N'qty', N'fa-table', 1, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (17, N'LcdBuyer', N'Completed PO', N'Completed PO', N'Completed POs', N'count', N'1:2', N'1:2', N'SELECT COUNT(*)  FROM LcdBuyerDB.Lcd.POHeader   WHERE POStatus  = ''C''', N'\\Home\\Error?page=detailed', NULL, N'bg-green', N'qty', N'fa-table', 1, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (18, N'LcdBuyer', N'Vendors', N'Vendors', N'Vendors', N'count_group', N'1:2', N'1:2', N' ', NULL, NULL, NULL, NULL, N'fa-user-plus', 0, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (19, N'LcdBuyer', N'New Vendors', N'New Vendors', N'New Vendors', N'count', N'1:2', N'1:2', N'SELECT COUNT(*)  FROM LcdBuyerDB.Dbo.SChools   WHERE Status  = ''N''', N'\\VendorInformation\\Option', NULL, N'bg-green', N'qty', N'fa-table', 1, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (20, N'LcdBuyer', N'Change Requests', N'Change REquest', N'Change Requests', N'count', N'1:2', N'1:2', N'SELECT COUNT(*)  FROM LcdBuyerDB.LCd.VendorChgReq   WHERE RequestStatus  = ''N''', N'\\VendorChangeRequest\\Option', NULL, N'bg-red', N'qty', N'fa-table', 1, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (21, N'LcdBuyer', N'Boxes', N'Boxes', N'Boxes', N'count_group', N'1:2', N'1:2', N' ', N'', NULL, NULL, NULL, N'fa-box', 0, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (22, N'LcdBuyer', N'New Box Requests', N'New Box Requests', N'New Box Requests', N'count', N'1:2', N'1:2', N'SELECT COUNT(*) FROM LcdBuyerDb.Lcd.BoxRequests WHERE ReqStatus = ''N''', N'\\BoxRequest\\Option', NULL, N'bg-red', N'qty', N'fa-table', 1, 1)
GO
INSERT [dbo].[IP_Widgets] ([WidgetId], [Company], [WidgetTitle], [WidgetTitleShort], [WidgetDesc], [WidgetType], [WidgetMinSize], [WidgetMaxSize], [WidgetQuery], [URL], [ColumnFormat], [BackgroundColor], [CountType], [WidgetIcon], [InGroup], [WidgetStatus]) VALUES (23, N'LcdBuyer', N'Approved not shipped', N'Not Shipped', N'Approved not shipped', N'count', N'1:2', N'1:2', N'SELECT COUNT(*) FROM LcdBuyerDb.Lcd.BoxRequests WHERE ReqStatus = ''A''', N'\\Shipment\\Option', NULL, N'bg-red', N'qty', N'fa-table', 1, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (3, 11, 1, 1, 2, 2)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (3, 15, 1, 1, 2, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (3, 18, 1, 3, 2, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (23, 3, 1, 1, 4, 2)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (23, 4, 3, 1, 2, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (23, 11, 1, 5, 2, 2)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (24, 4, 1, 1, 3, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (25, 1, 3, 5, 2, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (25, 2, 1, 3, 3, 2)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (25, 4, 1, 1, 2, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (25, 6, 3, 3, 2, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (25, 11, 2, 1, 2, 2)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (25, 14, 1, 5, 1, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (25, 15, 1, 3, 2, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (25, 18, 2, 1, 1, 2)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (25, 21, 1, 1, 2, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (30, 1, 4, 4, 2, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (30, 2, 1, 1, 3, 4)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (30, 3, 1, 4, 3, 2)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (30, 4, 3, 6, 2, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (30, 6, 3, 4, 2, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (30, 11, 1, 7, 2, 2)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (68, 1, 1, 1, 2, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (4730872, 1, 1, 5, 2, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (4730872, 2, 1, 7, 2, 2)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (4730872, 3, 1, 1, 2, 2)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (4730872, 4, 1, 3, 2, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (4730872, 6, 3, 1, 2, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (4730872, 11, 2, 3, 2, 2)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (4731139, 1, 1, 7, 2, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (4731139, 2, 1, 5, 2, 2)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (4731139, 3, 1, 1, 2, 2)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (4731139, 4, 3, 1, 1, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (4731139, 6, 2, 7, 2, 1)
GO
INSERT [dbo].[IP_WidgetsEmp] ([EmpId], [WidgetId], [WidgetPositionX], [WidgetPositionY], [WidgetSizeX], [WidgetSizeY]) VALUES (4731139, 11, 1, 3, 2, 2)
GO
ALTER TABLE [dbo].[IP_Widgets] ADD  CONSTRAINT [DF_IP_Widgets_InGroup]  DEFAULT ((0)) FOR [InGroup]
GO
ALTER TABLE [dbo].[IP_Widgets] ADD  CONSTRAINT [DF_IP_Widgets_WidgetStatus]  DEFAULT ((1)) FOR [WidgetStatus]
GO
