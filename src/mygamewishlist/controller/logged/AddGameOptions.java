package mygamewishlist.controller.logged;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Hashtable;

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
import mygamewishlist.model.pojo.ScrapedGame;
import mygamewishlist.model.pojo.db.User;
import mygamewishlist.model.pojo.db.WishListGame;
import mygamewishlist.model.pojo.db.WishListGameSteam;

/**
 * Servlet implementation class AddGameOptions
 */
@WebServlet("/AddGameOptions")
public class AddGameOptions extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private static final MyLogger LOG = MyLogger.getLOG();
	private static final ClassPaths cp = ClassPaths.getCP();
	
	private Hashtable<String,ArrayList<ScrapedGame>> games = new Hashtable<String,ArrayList<ScrapedGame>>();
	
	@EJB
	ClientSessionEJB sc_ejb;
	
	@EJB
	CreateQueryEJB cq_ejb;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			if (!sc_ejb.isSome1Logged(request.getSession(false))) {
				response.sendRedirect(cp.REDIRECT_LOGIN);
				return;
			}
			
			RequestDispatcher rd;
			
			if (!games.isEmpty()) {
				rd = getServletContext().getRequestDispatcher(cp.JSP_ADD_GAME_OPTIONS);
				request.setAttribute("stores", cq_ejb.getStoreNames());
				request.setAttribute("games", games);
			} else {
				rd = getServletContext().getRequestDispatcher(cp.MYLIST);
				request.setAttribute("error", "No games found with such parameters.");
			}
			
			rd.forward(request, response);
		} catch(Exception e) {
			LOG.logError(e.getMessage());
			RequestDispatcher rd = getServletContext().getRequestDispatcher(cp.MYLIST);
			rd.forward(request, response);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			User usr = sc_ejb.getLoggedUser(request);
			if (usr == null) {
				response.sendRedirect(cp.REDIRECT_LOGIN);
				return;
			}
			
			String[] id = request.getParameterValues("games");
			
			if (id != null) {
				cq_ejb.addGame2Wishlist(addGames(id, request), usr.getId());
				games.clear();
				response.sendRedirect(cp.REDIRECT_MYLIST);
			} else {
				ArrayList<String> stNames = cq_ejb.getStoreNames();
				
				for (String str : stNames) {
					@SuppressWarnings("unchecked")
					Hashtable<String,ArrayList<ScrapedGame>> tmp = (Hashtable<String,ArrayList<ScrapedGame>>)request.getAttribute(str);
					if (tmp != null) {
						if (tmp.isEmpty()) {
							games.put(str, new ArrayList<ScrapedGame>());
						} else {
							games.putAll(tmp);
						}						
					}
					
					request.removeAttribute(str);
				}
				
				doGet(request, response);
			}
		} catch(Exception e) {
			LOG.logError(e.getMessage());
			response.sendRedirect(cp.REDIRECT_MYLIST);
		}
	}
	
	private ArrayList<WishListGame> addGames(String[] id, HttpServletRequest request) {
		ArrayList<WishListGame> toInsert = new ArrayList<WishListGame>();
		
		for (String s : id) {			
			int arrPos = Integer.parseInt(s.substring(s.lastIndexOf("&") + 1));
			String store = s.substring(0,s.lastIndexOf("&"));			
			double max = -1;
			double min = -1;
			
			try {
				String minS = request.getParameter(store + "&min" + arrPos);
				String maxS = request.getParameter(store + "&max" + arrPos);
				
				if (!minS.equals("")) {
					min = Double.parseDouble(request.getParameter(store + "&min" + arrPos));
				}
				if (!maxS.equals("")) {
					max = Double.parseDouble(request.getParameter(store + "&max" + arrPos));
				}
			} catch (NumberFormatException e) {
				LOG.logError(e.getMessage());
			}		
			
			ArrayList<ScrapedGame> stGames = games.get(store);
			
			if (stGames == null) {
				continue;
			}
			
			ScrapedGame g = stGames.get(arrPos);
			
			WishListGame wlg;
			if (!store.equals("Steam")) {
				wlg = new WishListGame();
				wlg.setUrlGame(g.getUrlGame());
			} else {
				wlg = new WishListGameSteam();
				((WishListGameSteam) wlg).setAppid(Integer.parseInt(g.getUrlGame().substring(g.getUrlGame().lastIndexOf("/") + 1)));
				wlg.setUrlGame(g.getUrlGame());
			}
			
			wlg.setIdStore(cq_ejb.getStoreByName(store).getId());
			wlg.setGameName(g.getFullName());
			wlg.setDefaultPrice(g.getDefaultPrice());
			wlg.setCurrentPrice(g.getCurrentPrice());
			wlg.setDiscount(g.getCurrentDiscount());
			wlg.setImg(g.getImg());
			wlg.setMinPrice(min); 
			wlg.setMaxPrice(max);
			
			toInsert.add(wlg);
		}
		
		return toInsert;
	}
}
