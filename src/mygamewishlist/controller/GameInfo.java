package mygamewishlist.controller;

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
import mygamewishlist.model.pojo.db.Game;
import mygamewishlist.model.pojo.db.Review;
import mygamewishlist.model.pojo.db.ReviewOfGame;
import mygamewishlist.model.pojo.db.ReviewUser;
import mygamewishlist.model.pojo.db.User;

/**
 * @author Patryk
 *
 * Shows additional information about a game, and lets logged users make a review.
 */
@WebServlet("/GameInfo")
public class GameInfo extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private static final MyLogger LOG = MyLogger.getLOG();
	private static final ClassPaths cp = ClassPaths.getCP();
	
	private int idGame = -1;
	
	@EJB
	ClientSessionEJB sc_ejb;
	
	@EJB
	CreateQueryEJB cq_ejb;
	
	/**
	 * Shows info of the game
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			idGame = Integer.parseInt(request.getParameter("id"));
			
			Game g = cq_ejb.getGameById(idGame);
			User usr = sc_ejb.getLoggedUser(request);
			
			int idUser = usr == null ? -1 : usr.getId();
			
			RequestDispatcher rd = getServletContext().getRequestDispatcher(cp.JSP_GAME_INFO);
			request.setAttribute("game", g);
			request.setAttribute("reviews", cq_ejb.getGameReviews(idUser, g.getId()));
			ReviewOfGame rog = cq_ejb.getGameReview(idUser, g.getId());
			request.setAttribute("myReview", rog == null ? null : 
				new ReviewUser(rog.getReview(), rog.getRating(), "", g.getId()));
			
			rd.forward(request, response);
		} catch(Exception e) {
			LOG.logError(e.getMessage());
			RequestDispatcher rd = getServletContext().getRequestDispatcher(cp.REVIEW_LIST);
			rd.forward(request, response);
		}
	}

	/**
	 * Creates a review of the game
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			User usr = sc_ejb.getLoggedUser(request);
			double rating = Double.parseDouble(request.getParameter("rating"));
			String review = request.getParameter("review");
			
			if (usr == null || idGame == -1 || rating < 0 || rating > 10) {
				response.sendRedirect(cp.REDIRECT_REVIEW_LIST);
				return;
			}
			
			cq_ejb.addOrUpdateReview(new Review(usr.getId(), idGame, rating, review));
			response.sendRedirect(cp.REDIRECT_REVIEW_LIST);
		} catch(Exception e) {
			LOG.logError(e.getMessage());
			response.sendRedirect(cp.REDIRECT_REVIEW_LIST);
		}
	}
}
