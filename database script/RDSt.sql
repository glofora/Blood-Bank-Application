USE [RDS]
GO
/****** Object:  Table [dbo].[Histories]    Script Date: 09/18/2015 21:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Histories](
	[History] [int] IDENTITY(1,1) NOT NULL,
	[Member] [int] NOT NULL,
	[Date] [varchar](20) NOT NULL,
	[active] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[History] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Table [dbo].[Users]    Script Date: 09/18/2015 21:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[IsAdmin] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BloodGroups]    Script Date: 09/18/2015 21:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BloodGroups](
	[BloodGroup] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](15) NOT NULL,
	[Active] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BloodGroup] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Table [dbo].[Areas]    Script Date: 09/18/2015 21:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Areas](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](150) NOT NULL,
	[Active] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Donors]    Script Date: 09/18/2015 21:26:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Donors](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Age] [int] NOT NULL,
	[Gender] [nvarchar](10) NOT NULL,
	[Blood Group] [int] NOT NULL,
	[Address] [nchar](500) NULL,
	[Phone] [nvarchar](20) NOT NULL,
	[Area] [int] NOT NULL,
	[Active] [bit] NULL,
	[CreateDate] [varchar](20) NULL,
	[Second Name] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  StoredProcedure [dbo].[Deletedonor]    Script Date: 09/18/2015 21:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Deletedonor]
	@id int
AS
	if exists (select * from Donors where id=@id and Active=1 )
	Begin
	update Donors set Active =0 where id=@id and Active=1
	End
RETURN 0
GO
/****** Object:  StoredProcedure [dbo].[DeleteArea]    Script Date: 09/18/2015 21:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteArea]
	@Name varchar(50)
AS
declare @flag int;
	if exists(select b.Title from Donors a left join Areas b on a.Area=b.Id where b.Title=@Name and b.Active=1)
	begin
	set @flag=0
	end
	else
	begin
	set @flag=1
	update Areas set Active=0 where Title=@Name and Active=1
	end

return @flag;
GO
/****** Object:  StoredProcedure [dbo].[CreateDonor]    Script Date: 09/18/2015 21:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateDonor]
      @id int,
	  @Name NVARCHAR(150), 
	  @SecondName varchar(50),
      @Age INT, 
      @Gender NVARCHAR(10), 
      @BloodGroup INT, 
      @Address NCHAR(500), 
      @Phone NVARCHAR(20), 
      @Area INT 
AS
if exists(select * from Donors where Id=@id and Active=1)
begin
update Donors set Name=@Name,[Second Name]=@SecondName,Age=@Age,Gender=@Gender,[Blood Group]=@BloodGroup,Area=@Area,Address=@Address,Phone=@Phone
where Id=@id and Active=1
end
else
begin
insert into Donors(Name,[Second Name],Age,Gender,[Blood Group],Area,Address,Phone,Active,CreateDate) values (@Name,@SecondName,
@Age,@Gender,@BloodGroup,@Area,@Address,@Phone,1,GETDATE())
end
--exec [dbo].[CreateDonor]6,"fffdddddfff","kkjkj",3,"edddeee",4,"fffdddddddddfdddddfff","fffddddddddff",4
GO
/****** Object:  StoredProcedure [dbo].[CreateArea]    Script Date: 09/18/2015 21:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateArea]
	@Area Varchar(25)
AS
	Insert into Areas(Title,Active) values(@Area,1)
GO
/****** Object:  StoredProcedure [dbo].[GetAllDonatedHistories]    Script Date: 09/18/2015 21:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllDonatedHistories]

AS
	select a.Id as 'Donor ID',a.Name,c.Title as 'Blood Group',a.Phone,d.Title as Area, b.Date as 'Donated Date',
	 DATEDIFF(d,Date,GETDATE()) as 'Days After Donate' from Histories b
	 left join Donors a on a.Id=b.Member 
	left join BloodGroups c on a.[Blood Group]=c.BloodGroup
	left join Areas d on a.Area=d.Id
	where a.Active=1 and b.active=1
	
	

--exec [dbo].[GetAllDonatedHistories]
GO
/****** Object:  StoredProcedure [dbo].[GetallArea]    Script Date: 09/18/2015 21:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetallArea]

AS
	SELECT ROW_NUMBER() over( order by Id) as 'Si No' ,Title as 'Area Name' from Areas where Title!='Select Area'
RETURN 0

--exec [dbo].[GetallArea]
GO
/****** Object:  StoredProcedure [dbo].[SetDonatedhistory]    Script Date: 09/18/2015 21:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetDonatedhistory]
	@Member int
AS
	insert into Histories(Member,Date,active) values (@Member,GETDATE(),1)
GO
/****** Object:  UserDefinedFunction [dbo].[IsEligible]    Script Date: 09/18/2015 21:27:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IsEligible]
(
	@member int
)
RETURNS varchar(20)
AS
BEGIN
declare @result varchar(20)
if exists (select * from Histories a join Donors d on a.Member=d.Id  where
  DATEDIFF(d,a.Date,GETDATE())<90 and a.Member=@member and a.active=1)
  begin
	set @result = 'Not Eligible'
	End
	else
	begin
	if exists(select * from Donors where (DATEDIFF(d,CreateDate,GETDATE())/365+Age)<18 and Active=1 and Id=@member)
	begin
	set @result = 'Not Eligible'
	end
	else
	begin
		set @result ='Eligible'
		end
	end
	return @result
END
--[dbo].[IsEligible]('1')
GO
/****** Object:  StoredProcedure [dbo].[getallDonor]    Script Date: 09/18/2015 21:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[getallDonor]
AS
	SELECT	a.Id as 'Donor ID',(a.Name+' '+a.[Second Name]) as Name,b.Title as 'Blood group',a.Phone,c.Title as Area,a.Gender,(DATEDIFF(d,a.CreateDate,GETDATE())/365)+a.Age as Age,[dbo].[IsEligible](a.Id) as 'Donor Status'
	 from Donors a 
	left join BloodGroups b on a.[Blood Group]=b.BloodGroup
	left join Areas c on a.Area=c.Id where a.Active=1 

--[dbo].[getallDonor]
GO
