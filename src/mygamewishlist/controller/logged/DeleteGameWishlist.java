package mygamewishlist.controller.logged;

import java.io.IOException;

import javax.ejb.EJB;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mygamewishlist.model.ejb.ClientSessionEJB;
import mygamewishlist.model.ejb.CreateQueryEJB;
import mygamewishlist.model.pojo.ClassPaths;
import mygamewishlist.model.pojo.MyLogger;
import mygamewishlist.model.pojo.db.User;

/**
 * @author Patryk
 *
 * Servlet used for deleting games from wishlist
 */
@WebServlet("/DeleteGameWishlist")
public class DeleteGameWishlist extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private static final MyLogger LOG = MyLogger.getLOG();
	private static final ClassPaths cp = ClassPaths.getCP();
		
	@EJB
	ClientSessionEJB sc_ejb;
	
	@EJB
	CreateQueryEJB cq_ejb;
	
	/**
	 * Deletes game from wishlist
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		RequestDispatcher rd;
		try {
			User usr = sc_ejb.getLoggedUser(request);
			
			if (usr == null) {
				rd = getServletContext().getRequestDispatcher(cp.LOGIN);
				rd.forward(request, response);
				return;
			}
			
			String url = request.getParameter("url");
			
			cq_ejb.deleteGameWishlist(url, usr.getId());
		} catch(Exception e) {
			LOG.logError(e.getMessage());
		}
		rd = getServletContext().getRequestDispatcher(cp.MYLIST);
		request.setAttribute("r", "r");
		rd.forward(request, response);
	}
}
