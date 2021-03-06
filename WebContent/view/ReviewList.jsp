<%@page import="mygamewishlist.model.pojo.ClassPaths"%>
<%@page import="bomboshtml.body.Input"%>
<%@page import="bomboshtml.body.A"%>
<%@page import="bomboshtml.body.table.Tr"%>
<%@page import="bomboshtml.body.table.Table"%>
<%@page import="mygamewishlist.model.pojo.db.ReviewList"%>
<%@page import="java.util.ArrayList"%>
<%@page import="mygamewishlist.model.pojo.MyLogger"%>
<%@page import="mygamewishlist.model.pojo.db.User"%>
<%@page import="mygamewishlist.view.JspFunctions"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%!
	JspFunctions jspF = JspFunctions.getJspF();
	MyLogger log = MyLogger.getLOG();
	ClassPaths cp = ClassPaths.getCP();
%>

<%
	User usr = jspF.getLoggedUser(request.getSession(false));
%>

<html>
<jsp:include page="template/Head.jsp">
	<jsp:param name="" value="" />
</jsp:include>
<jsp:include page="template/BodyContainerFront.jsp">
	<jsp:param name="" value="" />
</jsp:include>
	<jsp:include page="template/Header.jsp">
		<jsp:param name="" value="" />
	</jsp:include>
	<% if (usr == null) { %>
	<jsp:include page="template/Nav.jsp">
		<jsp:param name="" value="" />
	</jsp:include>
	<% } else if (usr.getAdmin() == 1) { %>
	<jsp:include page="template/NavAdmin.jsp">
		<jsp:param name="" value="" />
	</jsp:include>
	<% } else { %>
	<jsp:include page="template/NavLogged.jsp">
		<jsp:param name="" value="" />
	</jsp:include>	
	<% } %>
	<jsp:include page="template/MainFront.jsp">
		<jsp:param name="" value="" />
	</jsp:include>	
		<div class="d-flex row justify-content-center">
		<%
			// Getting list of reviews
			@SuppressWarnings("unchecked")
			ArrayList<ReviewList> reviews = (ArrayList<ReviewList>)request.getAttribute("reviews");
			
			// Printing a list of games and their average rating
			for (ReviewList rl : reviews) {
				double avgRating = rl.getAverageRating();
				String rating = avgRating == -1 ? "-" : avgRating + "";
				// building link with id of the game as param
				StringBuilder sb = new StringBuilder()
						.append(cp.REDIRECT_GAME_INFO)
						.append("?id=")
						.append(rl.getIdGame());
				// getting random color
				String color = jspF.getPriceBgColor(avgRating);
		%>
			<div class="bg-gray col-xl-2 col-lg-3 col-md-4 col-sm-5 col-12 text-center ml-sm-4 ml-0 mt-3 px-2 row">
			 	<div class="row flex-row mx-auto">
				  	<div class="col-12 m-1 mt-2">
				    	<u><span class="h4"><% out.append(rl.getName()); %></span></u>
					</div>
			    <div class="col-12 d-flex mt-3 flex-row justify-content-center">
			        <div class="mr-3 my-auto">
			             Average score
			        </div>
			        <div class="ml-3 align-self-end my-auto">
			            <div class="<% out.append(color); %> p-2 h5 my-auto">
			                <% out.append(rating); %>
			            </div>
			        </div>
			    </div>
			    <div class="col-12 m-1 p-1">
			        <% out.append(rl.getGenres()); %>
			    </div>
			    <div class="col-12 d-flex mb-3">
			         <a class="btn btn-dark mx-auto mt-auto" href="<% out.append(sb.toString()); %>">
			             See more info
			         </a>
			    	</div>
				</div>
			</div>
		<% 
			}
			
			// div that contains numbers of pages
			StringBuilder sb = new StringBuilder().append("<div class='mt-3 justify-content-center d-flex col-12'>");
			
			// getting total number of pages, and current page number
			int noPags = (Integer)request.getAttribute("total");
			int pag = (Integer)request.getAttribute("pag");
			
			// adding all links to StringBuilder
			for (int i = 0; i < noPags; i++) {
				A a = new A((i + 1) + "", cp.REDIRECT_REVIEW_LIST + "?pag=" + i);					
				String color = i == pag ? "btn-primary" : "btn-dark";					
				a.addClass("btn " + color);
				
				sb.append("<div class='mx-1'>")
					.append(a.print())
					.append("</div>");
			}
			
			out.append(sb.append("<div>").toString());
		%>
        </div>
	<jsp:include page="template/MainBack.jsp">
		<jsp:param name="" value="" />
	</jsp:include>
	<jsp:include page="template/Footer.jsp">
		<jsp:param name="" value="" />
	</jsp:include>
<jsp:include page="template/BodyContainerBack.jsp">
	<jsp:param name="" value="" />
</jsp:include>
</html>