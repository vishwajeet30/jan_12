<%@ page language="java" import="java.sql.*, java.io.IOException, java.lang.*,java.text.*,java.util.*,java.awt.*,javax.naming.*,java.util.*,java.util.Calendar,java.util.Date,java.text.ParseException,java.text.SimpleDateFormat,java.util.Date,javax.sql.*,java.io.InputStream"%>
<%
Connection con = null;
try {

Class.forName("oracle.jdbc.driver.OracleDriver");
con = DriverManager.getConnection("jdbc:oracle:thin:@10.248.168.201:1521:ICSSP", "dashboard", "dash321");
PreparedStatement psMain = null;
PreparedStatement psTemp = null;
PreparedStatement psTempV = null;
ResultSet rs_icp = null;
ResultSet rsTemp = null;
///////////////////
%>
<!DOCTYPE html>
<html>
<head>

<meta http-equiv="refresh" content="600"> <!-- auto refresh the page after 3600 seconds -->
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">   

<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Arrival Count</title>
<link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
<link href="css/style1.css" rel="stylesheet" type="text/css">
<meta name="viewport" content="width=device-width, initial-scale=1">

<link rel="stylesheet" href="css/all.min.css" media="all">
<link rel="stylesheet" href="css/style.css" media="all">
<style>

.tableDesign {
	border-collapse: separate;
	border-spacing: 0;	
}
.tableDesign tr th, .tableDesign tr td {
	border-right: 1px solid #bbb;
	border-bottom: 1px solid #bbb;
	padding: 5px;
}

.tableDesign tr th:first-child, .tableDesign tr td:first-child {
	border-left: 1px solid #bbb;
}

.tableDesign tr th {
	background: #eee;
	border-top: 1px solid #bbb;
	text-align: left;
}

/* top-left border-radius */
.tableDesign tr:first-child th:first-child {
	border-top-left-radius: 10px;
}

/* top-right border-radius */
.tableDesign tr:first-child th:last-child {
	border-top-right-radius: 10px;
}

/* bottom-left border-radius */
.tableDesign tr:last-child td:first-child {
	border-bottom-left-radius: 10px;
}

/* bottom-right border-radius */
.tableDesign tr:last-child td:last-child {
	border-bottom-right-radius: 10px;
}

.right{
	text-align :right;
	}

</style>

</style>
<style>
body{font-family:Arial, Helvetica, sans-serif;}

</style>
<script>

		function compare_report()
		{
				document.entryfrm.target="_self";
				document.entryfrm.action="arr_query.jsp?&input_date_query="+document.entryfrm.input_date_query.value + "&hour="+document.entryfrm.hour.value + "&minute="+document.entryfrm.minute.value+ "&second="+document.entryfrm.second.value + "&hour2="+document.entryfrm.hour2.value + "&minute2="+document.entryfrm.minute2.value+ "&second2="+document.entryfrm.second2.value;

				document.entryfrm.submit();

				return true;
		}
</script>
<%@ page language = "java" import = "java.sql.*, java.io.*, java.awt.*, java.util.*, java.text.*, javax.naming.*, javax.sql.*"%>
</head>
<%///////////////////////////////////////////////%>
<body onload="DigitalTime(); StartTimer();" style="background-color: #ffffff;">

<table  class="table table-sm table-striped">
	<thead>
	<tr id='head1'>
		<th style="font-family: Arial;background-color: #1192e8; color: white; font-size: 25px;text-align: center;padding: 4px;">Arrival Count</th>
	</tr>
	</thead>
</table> 

		<!--   ************************START HOME DIV*******************HOME DIV*****************START HOME DIV****************START HOME DIV********  -->

		
		<%!
		// Function to Print numbers in Indian Format

		public String getIndianFormat(int num){

			String convertedNumber = "";
			int digitCount = 1;
			
			do{
				int currentDigit = num%10;
				num = num /10;
				if( digitCount%2 ==0 && digitCount!=2)
					convertedNumber = currentDigit + "," + convertedNumber;
				else
					convertedNumber = currentDigit + convertedNumber;
				digitCount++;
			
			}while(num>0);
			
			return convertedNumber;
		}
%>
<%!
    public String getPreviousDate(String inputDate) throws Exception {

		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
        // Parse the input date string to a Date object
        Date date = formatter.parse(inputDate);
        
        // Create a Calendar instance and set it to the input date
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        
        // Get the previous date
        calendar.add(Calendar.DAY_OF_MONTH, -1);
        
        // Format the previous date to the desired format
        return formatter.format(calendar.getTime());
    }
	
%>

<%!
    public String getNextDate(String inputDate) throws Exception {

		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
        // Parse the input date string to a Date object
        Date date = formatter.parse(inputDate);
        
        // Create a Calendar instance and set it to the input date
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        
        // Get the next date
        calendar.add(Calendar.DAY_OF_MONTH, 1);
        
        // Format the next date to the desired format
        return formatter.format(calendar.getTime());
    }

%>

<%!
    public  String convertToYYYYMMDD(String inputDate) {
        try {
            // Create a SimpleDateFormat object with the input format
            SimpleDateFormat inputFormat = new SimpleDateFormat("dd/MM/yyyy");
            
            // Parse the input date string to obtain a Date object
            Date date = inputFormat.parse(inputDate);
            
            // Create a SimpleDateFormat object with the desired output format
            SimpleDateFormat outputFormat = new SimpleDateFormat("yyyyMMdd");
            
            // Format the Date object to obtain the converted date string
            return outputFormat.format(date);
            
        } catch (ParseException e) {
            // Handle the ParseException if the input date string is invalid
            System.out.println("Invalid date format: " + inputDate);
            return null;
        }
    }
%>

<%!
    public  String convertFormat(String inputDate) {
        try {
            // Create a SimpleDateFormat object with the input format
            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
            
            // Parse the input date string to obtain a Date object
            Date date = inputFormat.parse(inputDate);
            
            // Create a SimpleDateFormat object with the desired output format
            SimpleDateFormat outputFormat = new SimpleDateFormat("dd/MM/yyyy");
            
            // Format the Date object to obtain the converted date string
            return outputFormat.format(date);
            
        } catch (ParseException e) {
            // Handle the ParseException if the input date string is invalid
            System.out.println("Invalid date format: " + inputDate);
            return null;
        }
    }
%>



<%/////////////////////////////////////////////////////////////////////////////////////////////////


String input_date_query = request.getParameter("input_date_query") == null ? "" : request.getParameter("input_date_query");

String hour = request.getParameter("hour") == null ? "" : request.getParameter("hour");
if(hour.length()<2){hour = "0" + hour;}
String minute = request.getParameter("minute") == null ? "" : request.getParameter("minute");
if(minute.length()<2){minute = "0" + minute;}
String second = request.getParameter("second") == null ? "" : request.getParameter("second");
if(second.length()<2){second = "0" + second;}

String hour2 = request.getParameter("hour2") == null ? "" : request.getParameter("hour2");
if(hour2.length()<2){hour2 = "0" + hour2;}
String minute2 = request.getParameter("minute2") == null ? "" : request.getParameter("minute2");
if(minute2.length()<2){minute2 = "0" + minute2;}
String second2 = request.getParameter("second2") == null ? "" : request.getParameter("second2");
if(second2.length()<2){second2 = "0" + second2;}


///////////////////////////////////////////////////////////////////////////////////////////////////////
String test_d = "2024-01-30";
	String Arr_Count_Query = "";
	String input_date_query_z = "";
	input_date_query_z = convertFormat(input_date_query);


%>
<div class="container">
<div class="row" style="margin-top: 0px;">
<div class="col-sm-12" style="margin: auto;">
<table style="background-color:#e8ecf1;border-radius: 5px;">
	<tr style="font-size: 30px;  text-align: left; color:white; height:20px; ">
	  <th style="border-color: #D0DDEA;">

		<form name="entryfrm" method="post">
		  <!-- <input class="input" type="hidden" name="ReverseCounterID" size="55" maxlength="55" value="600"> -->
			<table align="center" width="80%" cellspacing="0"  cellpadding="4" border="0">
				<tr bgcolor="#e8ecf1">
					<td style="text-align: left;">
					&nbsp;&nbsp;
					<font face="Verdana" color="#347FAA" size="2"><b>&nbsp;Date&nbsp;&nbsp;</b>
					<input type="date" required step="1" name="input_date_query" height="40"  style="width:150px; color:black;font-weight:bold; height: 28px; background-color: white; font-size=12pt;font-family:Verdana" required>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

					From&nbsp;&nbsp;Hrs&nbsp;<input type="number" required step="1" size="2" min="00" max="23" id="hour" name="hour" height="40" maxlength="2" style="width:50px; color:black;font-weight:bold; height: 28px; background-color: white; font-size=12pt;font-family:Verdana" required>
					&nbsp;
					Mts&nbsp;<input type="number" required step="1" size="2" min="00" max="59" id="minute" name="minute" height="40" maxlength="2" style="width:50px; color:black;font-weight:bold; height: 28px; background-color: white; font-size=12pt;font-family:Verdana">
					&nbsp;
					Sec&nbsp;<input type="number" required step="1" size="2" min="00" max="59" id="second" name="second" height="40" maxlength="2" style="width:50px; color:black;font-weight:bold; height: 28px; background-color: white; font-size=12pt;font-family:Verdana">

					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;


					To&nbsp;&nbsp;Hrs&nbsp;<input type="number" required step="1" size="2" min="00" max="23" id="hour2" name="hour2" height="40" maxlength="2" style="width:50px; color:black;font-weight:bold; height: 28px; background-color: white; font-size=12pt;font-family:Verdana" required>
					&nbsp;
					Mts&nbsp;<input type="number" required step="1" size="2" min="00" max="59" id="minute2" name="minute2" height="40" maxlength="2" style="width:50px; color:black;font-weight:bold; height: 28px; background-color: white; font-size=12pt;font-family:Verdana">
					&nbsp;
					Sec&nbsp;<input type="number" required step="1" size="2" min="00" max="59" id="second2" name="second2" height="40" maxlength="2" style="width:50px; color:black;font-weight:bold; height: 28px; background-color: white; font-size=12pt;font-family:Verdana">


					<!-- <input type="time" name="time_query" height="40"  style="width:200px; color:black;font-weight:bold; height: 28px; background-color: white; font-size=12pt;font-family:Verdana" size="10" maxlength="10"  autocomplete="off" > -->
					
					<!-- <input type="datetime-local" name="time_query" height="40"  style="width:200px; color:black;font-weight:bold; height: 28px; background-color: white; font-size=12pt;font-family:Verdana" size="10" maxlength="10"  autocomplete="off" > -->

					<!-- <input type="number" name="input_date_queryy" height="40"  style="width:200px; color:black;font-weight:bold; height: 28px; background-color: white; font-size=12pt;font-family:Verdana" size="10" maxlength="10"  autocomplete="off" > -->

					
					<!-- <font face="Verdana" color="#347FAA" size="2"><b>&nbsp;Date&nbsp;(dd/mm/yyyy)&nbsp;</b>
					<input type="date" name="input_date_query" height="40"  style="width:200px; color:black;font-weight:bold; height: 28px; background-color: white; font-size=12pt;font-family:Verdana" size="10" maxlength="10"  autocomplete="on" onkeyup="filtery(this.value,this.form.compare_icp)" onchange="filtery(this.value,this.form.compare_icp)" onKeyDown="if(event.keyCode==13) event.keyCode=9;if (event.keyCode==8) event.keyCode=37+46;" onKeyPress="return letternumber(event, '1234567890/)"> -->

					
					<!-- <label for="start">Start date : </lable>
					<input type="date" id="start" name="trip-start" value="2024/07/11" min="2010/07/11" max="2010/07/11"> -->
					
					<!-- <font face="Verdana" color="#347FAA" size="2"><b>&nbsp;Table Type&nbsp;</b>
					<select class="form-select-sm" name="table_type" onKeyDown="if(event.keyCode==13) event.keyCode=9;">
						<option value="IM_TRANS_ARR_TOTAL">IM_TRANS_ARR_TOTAL</option>
						<option value="IM_TRANS_DEP_TOTAL">IM_TRANS_DEP_TOTAL</option>
					</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	
 -->
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<button class="btn btn-primary btn-md" type="button" onClick="compare_report()"> Submit </button>
					</td>
				</tr>
			</table>
		</form>
		
	  </th>
	</tr>
</table>
<%if(!input_date_query_z.equals(null))
	{
%>
	<font face="Verdana" color="#347FAA" size="2" style="font-weight:normal;">Entered Date :- <%=input_date_query_z%></font>&nbsp;&nbsp;&nbsp;&nbsp;
	<font face="Verdana" color="#347FAA" size="2" style="font-weight:normal;">From Time :- <%=hour +":"+ minute +":"+ second%></font>&nbsp;&nbsp;&nbsp;
	<font face="Verdana" color="#347FAA" size="2" style="font-weight:normal;">To Time :- <%=hour2 +":"+ minute2 +":"+ second2%></font>
<%  }
%>

</div>
</div>
</div>
<br><br>
<%
	//String inputQueryDate = "";
	//String queryDate = "input_date_query";
	//String queryDate = "03/01/2024";
	//out.println("Helloooo"+input_date_query_z);
	String queryDate_less = getPreviousDate(input_date_query_z);
	//out.println(queryDate_less);
	//String queryDate_less = "07/01/2024";
	String queryDate_plus = getNextDate(input_date_query_z);
	//out.println(queryDate_plus);
	String input_date_query_YYYYMMDD = convertToYYYYMMDD(input_date_query_z);
	String input_date_query_YYYYMMDD_000000 = convertToYYYYMMDD(input_date_query_z) + hour + minute + second;
	String input_date_query_YYYYMMDD_235959 = convertToYYYYMMDD(input_date_query_z) + hour2 + minute2 + second2;
	String input_date_query_YYYYMMDD_0000 = convertToYYYYMMDD(input_date_query_z) + hour + minute + second;
	String input_date_query_YYYYMMDD_2359 = convertToYYYYMMDD(input_date_query_z) + hour2 + minute2 + second2;

	//out.println("<br>"+input_date_query_YYYYMMDD_000000);
	//out.println("<br>"+input_date_query_YYYYMMDD_235959);  



	////////////////	Table -  Indian UCF Matched/Not Matched Statistics in last 7 days - Start	///////////////////////%>
<div class="container-fluid">
<div class="row">
	<div class="col-sm-12" style="margin:auto;">
	<table class="tableDesign">
		<tr style="font-size: 28px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
			<th colspan="3" style="text-align: center;background-color:#e72a5c;border-color: #e72a5c; text-align: center;">Arrival&nbsp;Count</th>
		</tr>
		<tr style="font-size: 18px; font-family: 'Arial', serif;color: white; font-weight: bold; text-align: center;border-color: #1192e8;height:40px;">
			<th style="text-align: center;background-color:#e93d6b;border-color: #A4133C;width:5%;">S.No.</th>
			<th style="text-align: left;background-color:#e93d6b;border-color: #A4133C;width:87%;">Arrival&nbsp;Query</th>
			<th style="text-align: right;background-color:#e93d6b;border-color: #A4133C;width:8%;">Count</th>
		</tr>
<%
int count_boarding_date_main_1 = 0;
int count_boarding_date_2 = 0;
int count_boarding_date_3 = 0;
int count_boarding_date_4 = 0;

int count_pax_chk_date_main_5 = 0;
int count_pax_chk_date_6 = 0;
int count_pax_chk_date_7 = 0;
int count_pax_chk_date_8 = 0;
////////////////////////////////////////////////////////////////////////
		try 
		{
				Arr_Count_Query = "select count(1) as ccount from im_trans_arr_total@DBL_IVFRT004 where pax_boarding_date = to_date('"+ input_date_query_z +"','dd/mm/yyyy')";
				//out.println(Arr_Count_Query);
				psTemp = con.prepareStatement(Arr_Count_Query);
				rsTemp = psTemp.executeQuery();
				while (rsTemp.next()) 
				{
				count_boarding_date_main_1 = rsTemp.getInt("ccount");
%>
				<tr style="font-size: 16px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold;text-align: center; width:5%;">i.</td>
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: normal;text-align: left; width:87%;">Pax Count for Pax boarding date = <%=input_date_query_z%></td>
					<td style="font-size: 18px;background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;width:8%;"><%=rsTemp.getInt("ccount") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("ccount"))%>&nbsp;</td>
				</tr>
<%
				}
		rsTemp.close();
		} catch (Exception e) {out.println(e);}
///////////////////////////////////////////////////////////////////////////
		try 
		{
				Arr_Count_Query = "select count(1) as ccount from im_trans_arr_total@DBL_IVFRT004 where pax_boarding_date = to_date('"+ input_date_query_z +"','dd/mm/yyyy') and pax_chk_date = to_date('" + queryDate_less + "','dd/mm/yyyy')" ;
				psTemp = con.prepareStatement(Arr_Count_Query);
				rsTemp = psTemp.executeQuery();
				while (rsTemp.next()) 
				{
				count_boarding_date_2 = rsTemp.getInt("ccount");
%>
				<tr style="font-size: 16px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold;text-align: center; width:5%;">ii.</td>
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: normal;text-align: left; width:87%;">Pax Count for Pax boarding date = <%=input_date_query_z%> and Pax Check date = <%=queryDate_less%></td>
					<td style="font-size: 18px;background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;width:8%;"><%=rsTemp.getInt("ccount") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("ccount"))%>&nbsp;</td>
				</tr>
<%
				}
		rsTemp.close();
		} catch (Exception e) {out.println(e);}
///////////////////////////////////////////////////////////////////////////
		try 
		{
				Arr_Count_Query = "select count(1) as ccount from im_trans_arr_total@DBL_IVFRT004 where pax_boarding_date = to_date('"+ input_date_query_z +"','dd/mm/yyyy') and pax_chk_date = to_date('" + queryDate_plus + "','dd/mm/yyyy')" ;
				psTemp = con.prepareStatement(Arr_Count_Query);
				rsTemp = psTemp.executeQuery();
				while (rsTemp.next()) 
				{
				count_boarding_date_3 = rsTemp.getInt("ccount");
%>
				<tr style="font-size: 16px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold;text-align: center; width:5%;">iii.</td>
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: normal;text-align: left; width:87%;">Pax Count for Pax boarding date = <%=input_date_query_z%> and Pax Check date = <%=queryDate_plus%></td>
					<td style="font-size: 18px;background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;width:8%;"><%=rsTemp.getInt("ccount") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("ccount"))%>&nbsp;</td>
				</tr>
<%
				}
		rsTemp.close();
		} catch (Exception e) {out.println(e);}
///////////////////////////////////////////////////////////////////////////
		try 
		{
				Arr_Count_Query = "select count(1) as ccount from im_trans_arr_total@DBL_IVFRT004 where pax_boarding_date = to_date('"+ input_date_query_z +"','dd/mm/yyyy') and pax_chk_date = to_date('" + input_date_query_z + "','dd/mm/yyyy')" ;
				psTemp = con.prepareStatement(Arr_Count_Query);
				rsTemp = psTemp.executeQuery();
				while (rsTemp.next()) 
				{
				count_boarding_date_4 = rsTemp.getInt("ccount");
%>
				<tr style="font-size: 16px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold;text-align: center; width:5%;">iv.</td>
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: normal;text-align: left; width:87%;">Pax Count for Pax boarding date = <%=input_date_query_z%> and Pax Check date = <%=input_date_query_z%></td>
					<td style="font-size: 18px;background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;width:8%;"><%=rsTemp.getInt("ccount") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("ccount"))%>&nbsp;</td>
				</tr>
<%
				}
		rsTemp.close();
		} catch (Exception e) {out.println(e);}
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
%>
				<tr style="font-size: 16px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
					<td style="background-color:#ffdbe5;border-color:#A4133C; font-weight: bold;text-align: center; width:5%;">...</td>
					<td style="background-color:#ffdbe5;border-color:#A4133C; font-weight: bold;text-align: left; width:87%;font-size:16px;">Is (ii + iii + iv) = i&nbsp;&nbsp;&nbsp;&nbsp;(Yes/No)</td>
<%					if(count_boarding_date_main_1 == (count_boarding_date_2 + count_boarding_date_3 + count_boarding_date_4))
					{ 
%>					
						<td style="font-size: 18px;background-color:#ffdbe5;border-color:#A4133C; font-weight: bold; text-align: right;width:8%;">Yes&nbsp;</td>
<%					}else
					  {
%>						
						<td style="font-size: 18px;background-color:red;border-color:#A4133C; font-weight: bold; text-align: right;width:8%;">No&nbsp;</td>
<%						
					  }
%>
				</tr>

<%

////////////////////////////////////////////////////////////////////////
///////////////////////////////////Second/////////////////////////////////////
		try 
		{
				Arr_Count_Query = "select count(1) as ccount from im_trans_arr_total@DBL_IVFRT004 where pax_chk_date = to_date('"+ input_date_query_z +"','dd/mm/yyyy')";
				psTemp = con.prepareStatement(Arr_Count_Query);
				rsTemp = psTemp.executeQuery();
				while (rsTemp.next()) 
				{
				count_pax_chk_date_main_5 = rsTemp.getInt("ccount");
%>
				<tr style="font-size: 16px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold;text-align: center; width:5%;">v.</td>
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: normal;text-align: left; width:87%;">Pax Count for Pax Check date = <%=input_date_query_z%></td>
					<td style="font-size: 18px;background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;width:8%;"><%=rsTemp.getInt("ccount") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("ccount"))%>&nbsp;</td>
				</tr>
<%
				}
		rsTemp.close();
		} catch (Exception e) {out.println(e);}
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
		try 
		{
				Arr_Count_Query = "select count(1) as ccount from im_trans_arr_total@DBL_IVFRT004 where pax_chk_date = to_date('"+ input_date_query_z +"','dd/mm/yyyy') and pax_boarding_date = to_date('" + queryDate_less + "','dd/mm/yyyy')" ;
				psTemp = con.prepareStatement(Arr_Count_Query);
				rsTemp = psTemp.executeQuery();
				while (rsTemp.next()) 
				{
				count_pax_chk_date_6 = rsTemp.getInt("ccount");
%>
				<tr style="font-size: 16px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold;text-align: center; width:5%;">vi.</td>
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: normal;text-align: left; width:87%;">Pax Count for Pax Check date = <%=input_date_query_z%> and Pax Boarding Date = <%=queryDate_less%></td>
					<td style="font-size: 18px;background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;width:8%;"><%=rsTemp.getInt("ccount") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("ccount"))%>&nbsp;</td>
				</tr>
<%
				}
		rsTemp.close();
		} catch (Exception e) {out.println(e);}
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
		try 
		{
				Arr_Count_Query = "select count(1) as ccount from im_trans_arr_total@DBL_IVFRT004 where pax_chk_date = to_date('"+ input_date_query_z +"','dd/mm/yyyy') and pax_boarding_date  = to_date('" + queryDate_plus + "','dd/mm/yyyy')" ;
				psTemp = con.prepareStatement(Arr_Count_Query);
				rsTemp = psTemp.executeQuery();
				while (rsTemp.next()) 
				{
				count_pax_chk_date_7 = rsTemp.getInt("ccount");
%>
				<tr style="font-size: 16px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold;text-align: center; width:5%;">vii.</td>
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: normal;text-align: left; width:87%;">Pax Count for Pax Check date = <%=input_date_query_z%> and Pax Boarding Date = <%=queryDate_plus%></td>
					<td style="font-size: 18px;background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;width:8%;"><%=rsTemp.getInt("ccount") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("ccount"))%>&nbsp;</td>
				</tr>
<%
				}
		rsTemp.close();
		} catch (Exception e) {out.println(e);}
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
		try 
		{
				Arr_Count_Query = "select count(1) as ccount from im_trans_arr_total@DBL_IVFRT004 where pax_chk_date = to_date('"+ input_date_query_z +"','dd/mm/yyyy') and pax_boarding_date = to_date('" + input_date_query_z + "','dd/mm/yyyy')" ;
				psTemp = con.prepareStatement(Arr_Count_Query);
				rsTemp = psTemp.executeQuery();
				while (rsTemp.next()) 
				{
				count_pax_chk_date_8 = rsTemp.getInt("ccount");
%>
				<tr style="font-size: 16px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold;text-align: center; width:5%;">viii.</td>
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: normal;text-align: left; width:87%;">Pax Count for Pax Check date = <%=input_date_query_z%> and Pax Boarding Date = <%=input_date_query_z%></td>
					<td style="font-size: 18px;background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;width:8%;"><%=rsTemp.getInt("ccount") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("ccount"))%>&nbsp;</td>
				</tr>
<%
				}
		rsTemp.close();
		} catch (Exception e) {out.println(e);}
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////


%>
				<tr style="font-size: 16px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
					<td style="background-color:#ffdbe5;border-color:#A4133C; font-weight: bold;text-align: center; width:5%;">...</td>
					<td style="background-color:#ffdbe5;border-color:#A4133C; font-weight: bold;text-align: left; width:87%;font-size:16px;">Is (vi + vii + viii) = v&nbsp;&nbsp;&nbsp;&nbsp;(Yes/No)</td>
<%					if(count_pax_chk_date_main_5 == (count_pax_chk_date_6 + count_pax_chk_date_7 + count_pax_chk_date_8))
					{ 
%>					
						<td style="font-size: 18px;background-color:#ffdbe5;border-color:#A4133C; font-weight: bold; text-align: right;width:8%;">Yes&nbsp;</td>
<%					}else
					  {
%>						
						<td style="font-size: 18px;background-color:red;border-color:#A4133C; font-weight: bold; text-align: right;width:8%;">No&nbsp;</td>
<%						
					  }
%>
				</tr>

<%

////////////////////////////////////////////////////////////////////////
		try 
		{
		
				//Arr_Count_Query = "select count(1) as ccount from im_trans_arr_total@DBL_IVFRT004 where pax_boarding_date >= to_date('" + input_date_query_z + "','dd/mm/yyyy') and pax_boarding_date <= to_date('" + input_date_query_z + "','dd/mm/yyyy') and  TO_CHAR(PAX_CHK_DATE,'YYYYMMDD') || PAX_CHK_TIME >= '20240103000000' AND TO_CHAR(PAX_CHK_DATE,'YYYYMMDD') || PAX_CHK_TIME <= '20240103235959'" ;
				Arr_Count_Query = "select count(1) as ccount from im_trans_arr_total@DBL_IVFRT004 where pax_boarding_date >= to_date('" + input_date_query_z + "','dd/mm/yyyy') and pax_boarding_date <= to_date('" + input_date_query_z + "','dd/mm/yyyy') and  TO_CHAR(PAX_CHK_DATE,'YYYYMMDD') || PAX_CHK_TIME >= '" + input_date_query_YYYYMMDD_000000 + "' AND TO_CHAR(PAX_CHK_DATE,'YYYYMMDD') || PAX_CHK_TIME <= '" + input_date_query_YYYYMMDD_235959 + "'" ;
				psTemp = con.prepareStatement(Arr_Count_Query);
				rsTemp = psTemp.executeQuery();
				while (rsTemp.next()) 
				{
%>
				<tr style="font-size: 16px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold;text-align: center; width:5%;">ix.</td>
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: normal;text-align: left; width:87%;"><%=Arr_Count_Query%></td>
					<td style="font-size: 18px;background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;width:8%;"><%=rsTemp.getInt("ccount") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("ccount"))%>&nbsp;</td>
				</tr>
<%
				}
		rsTemp.close();
		} catch (Exception e) {out.println(e);}
///////////////////////////////////////////////////////////////////////////
		try 
		{
				//Arr_Count_Query = "select count(1) as ccount from im_trans_arr_total@DBL_IVFRT004 where pax_boarding_date >= to_date('" + queryDate_less + "','dd/mm/yyyy') and pax_boarding_date <= to_date('" + queryDate_plus + "','dd/mm/yyyy') and  TO_CHAR(PAX_CHK_DATE,'YYYYMMDD') || PAX_CHK_TIME >= '202401030000' AND TO_CHAR(PAX_CHK_DATE,'YYYYMMDD') || PAX_CHK_TIME <= '202401032359'" ;
				Arr_Count_Query = "select count(1) as ccount from im_trans_arr_total@DBL_IVFRT004 where pax_boarding_date >= to_date('" + input_date_query_z + "','dd/mm/yyyy') and pax_boarding_date <= to_date('" + input_date_query_z + "','dd/mm/yyyy') and  TO_CHAR(PAX_CHK_DATE,'YYYYMMDD') || PAX_CHK_TIME >= '"+ input_date_query_YYYYMMDD_0000 +"' AND TO_CHAR(PAX_CHK_DATE,'YYYYMMDD') || PAX_CHK_TIME <= '" + input_date_query_YYYYMMDD_2359 + "'" ;
				psTemp = con.prepareStatement(Arr_Count_Query);
				rsTemp = psTemp.executeQuery();
				while (rsTemp.next()) 
				{
%>
				<tr style="font-size: 16px; font-family: 'Arial', serif; border-color: #6929c4;height:18px;">
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: bold;text-align: center; width:5%;">x.</td>
					<td style="background-color:#ffeeee;border-color:#A4133C; font-weight: normal;text-align: left; width:87%;"><%=Arr_Count_Query%></td>
					<td style="font-size: 18px;background-color:#ffeeee;border-color:#A4133C; font-weight: bold; text-align: right;width:8%;"><%=rsTemp.getInt("ccount") == 0 ? "&nbsp;": getIndianFormat(rsTemp.getInt("ccount"))%>&nbsp;</td>
				</tr>
<%
				}
		rsTemp.close();
		} catch (Exception e) {out.println(e);}
///////////////////////////////////////////////////////////////////////////
		psTemp.close();
	%>		
	</table>
		</div>
		</div>
		</div>
<%///////////////////////////////////////////////////////////////////////%>
<%
} catch (Exception e) {
e.printStackTrace();
} 

finally 
	{
		try
		{
			if (con != null)
					{
					con.close();    
					}
			/*if (ctx != null)
					{
					ctx.close();
					}*/
		}
	catch(Exception e)
	{
		//out.println(e.getMessage());
	}
}
%>
		</body>
		</html>




















