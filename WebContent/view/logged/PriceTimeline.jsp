<%@page import="java.awt.Color"%>
<%@page import="bomboshtml.body.A"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.time.LocalDate"%>
<%@page import="org.json.JSONArray"%>
<%@page import="mygamewishlist.model.pojo.db.TimelineGameDetailed"%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.ArrayList"%>
<%@page import="mygamewishlist.model.pojo.db.User"%>
<%@page import="mygamewishlist.model.pojo.ClassPaths"%>
<%@page import="mygamewishlist.model.pojo.MyLogger"%>
<%@page import="mygamewishlist.view.JspFunctions"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE>

<%!
	JspFunctions jspF = JspFunctions.getJspF();
	MyLogger log = MyLogger.getLOG();
	ClassPaths cp = ClassPaths.getCP();
%>

<%
	User usr = jspF.getLoggedUser(request.getSession(false));

	if (usr == null) {
		response.sendRedirect(cp.REDIRECT_LOGIN);
	}
%>

<html>
<jsp:include page="../template/Head.jsp">
	<jsp:param name="js" value="Chart" />
</jsp:include>
<jsp:include page="../template/BodyContainerFront.jsp">
	<jsp:param name="" value="" />
</jsp:include>
	<jsp:include page="../template/Header.jsp">
		<jsp:param name="" value="" />
	</jsp:include>
	<% if (usr.getAdmin() == 1) { %>
	<jsp:include page="../template/NavAdmin.jsp">
		<jsp:param name="" value="" />
	</jsp:include>
	<% } else { %>
	<jsp:include page="../template/NavLogged.jsp">
		<jsp:param name="" value="" />
	</jsp:include>	
	<% } %>

	<jsp:include page="../template/MainFront.jsp">
		<jsp:param name="" value="" />
	</jsp:include>
		<div id="chartContainer" style="width: 100%; height: 80vh;" class="m-auto color-white">
            <canvas id="ctx" class="bg-gray color-white">
                <script>
	                <%
	                // getting all of the object lists
	                @SuppressWarnings("unchecked")
	                Hashtable<String, ArrayList<TimelineGameDetailed>> list = 
	                	(Hashtable<String, ArrayList<TimelineGameDetailed>>)request.getAttribute("list");
	                @SuppressWarnings("unchecked")
	                List<LocalDate> dates = (List<LocalDate>)request.getAttribute("dates");
	                JSONArray labels = new JSONArray();
	                
	                if (list == null || dates == null) {
	                	response.sendRedirect(cp.REDIRECT_MYLIST);
	                }
	                
	                // creating all of the labels with dates.
	                for (LocalDate ld : dates) {
	                	labels.put(ld);
	                }
	                %>
	                // getting canvas context
                    var ctx = document.getElementById("ctx").getContext('2d');
	                // creating chart
                    var chart = new Chart(ctx, {
                        type: 'line',
                        data: {
                        	// printing labels
                            labels: <% out.append(labels.toString()); %>,
                            datasets: [
                            <%
                            // generating list with random colors
                            ArrayList<Color> colors = jspF.generateColors(list.size());                            
                            int i = 0;
                            for (Entry<String, ArrayList<TimelineGameDetailed>> entry : list.entrySet()) {
                            	JSONArray jsArr = new JSONArray();
                            	// getting colors
                            	Color c = colors.get(i);
                            	// generating html rgb color
                            	String color = new StringBuilder()
                            			.append("rgb(")
                       					.append(c.getRed())
                       					.append(",")
                       					.append(c.getBlue())
                       					.append(",")
                       					.append(c.getGreen())
                       					.append(")")
                       					.toString();
                            	
                            	// adding prices to timeline
                            	for (TimelineGameDetailed tlgd : entry.getValue()) {
                            		jsArr.put(tlgd.getPrice() == 0 ? null : tlgd.getPrice());
                            	}
                            %>	                            
	                        	{
	                        		// generating line
	                            	label: "<% out.print(entry.getKey()); %>",
	                            	fill: false,
	                                lineTension: 0,
	                                backgroundColor: "rgba(75, 192, 192, 0.4)",
	                                borderColor: "<% out.append(color.toString()); %>",
	                                pointBorderColor: "<% out.append(color.toString()); %>",
	                                pointBackgroundColor: "<% out.append(color.toString()); %>",
	                                pointHoverRadius: 5,
	                                pointHitRadius: 10,		                          
	                        		data: <% out.append(jsArr.toString()); %>,
	                            },		                        
                        	<%
                        		i++;
                            }
                    		%>
                    		],
                        },                            
                        options: {
                        	responsive: true,
                        	maintainAspectRatio: false,
                            scales: {
                                yAxes: [{
                                    ticks: {
                                        beginAtZero: true
                                    }
                                }]
                            },
                            legend: {
                                labels: {
                                    fontColor: "white"
                                }
                            },
                            scales: {
                                yAxes: [{
                                    ticks: {
                                        fontColor: "white"
                                    }
                                }],
                                xAxes: [{
                                    ticks: {
                                        fontColor: "white"
                                    }
                                }]
                            }
                        }
                    });
                </script>
            </canvas>
        </div>
	<jsp:include page="../template/MainBack.jsp">
		<jsp:param name="" value="" />
	</jsp:include>
	<jsp:include page="../template/Footer.jsp">
		<jsp:param name="" value="" />
	</jsp:include>
<jsp:include page="../template/BodyContainerBack.jsp">
	<jsp:param name="" value="" />
</jsp:include>