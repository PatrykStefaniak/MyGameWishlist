package mygamewishlist.model.ejb;

import javax.ejb.LocalBean;
import javax.ejb.Stateless;

import mygamewishlist.model.dao.GameDAO;
import mygamewishlist.model.dao.ListDAO;
import mygamewishlist.model.dao.ReviewDAO;
import mygamewishlist.model.dao.UserDAO;
import mygamewishlist.model.pojo.User;

@Stateless
@LocalBean
public class CreateQuery {

	private static final UserDAO USR_DAO = new UserDAO();
	private static final GameDAO GAME_DAO = new GameDAO();
	private static final ListDAO LIST_DAO = new ListDAO();
	private static final ReviewDAO REV_DAO = new ReviewDAO();
	
	public CreateQuery() {}
	
	public User getUserByEmail(String email) {
		return USR_DAO.getUserByEmail(email);
	}
	
	public void addUser(User usr) {
		USR_DAO.addUser(usr);
	}
}