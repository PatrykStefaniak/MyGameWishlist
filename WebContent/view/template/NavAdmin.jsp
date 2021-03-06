<%@page import="mygamewishlist.view.JspFunctions"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%!JspFunctions jspF = JspFunctions.getJspF();%>

<nav class="col-12">
	<div class="w-75 row mx-auto">
		<div class="col-md-6 col-sm-12 navbar navbar-expand ">
			<button class="nav-link btn btn-dark dropdown-toggle mr-1" type="button" id="dropdownReviews" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Reviews</button>
	        <div class="dropdown-menu color-black" aria-labelledby="dropdownReviews">
			    <a class="dropdown-item" href="/ReviewList">Reviews</a>
			    <a class="dropdown-item" href="/UserReviews">My Reviews</a>
			</div>
			<ul class="navbar-nav mx-auto mx-lg-0 mr-lg-auto">
	            <li class="nav-link px-1"><a href="/MyList" class="nav-link btn btn-dark">My List</a></li>
				<li class="nav-link px-1"><a href="/GameList" class="nav-link btn btn-dark">Game List</a></li>
			</ul>
		</div>
		<div class="col-md-3 col-sm-12 d-flex ml-md-auto">
			<%
				if (jspF.getLoggedUser(request.getSession(false)) == null) {
			%>
			<div class="g-signin2 color-black my-auto mx-md-0 mx-auto ml-md-auto" data-onsuccess="onSignIn" id="myP"></div>
			<%
				} else {
			%>
			<button class="logout color-black my-auto mx-md-0 mx-auto ml-md-auto">Sign Out</button>
			<%
				}
			%>
		</div>
	</div>
</nav>