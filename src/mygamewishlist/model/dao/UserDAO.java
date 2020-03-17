package mygamewishlist.model.dao;

import org.apache.ibatis.session.SqlSession;

import mygamewishlist.model.dao.mapper.UserMapper;
import mygamewishlist.model.pojo.MyLogger;
import mygamewishlist.model.pojo.User;

public class UserDAO {

	private static final MyLogger LOG = MyLogger.getLOG();
	private static SqlSession session;
	private static UserMapper userMapper;
	
	/**
	 * Crea la conexion con la base de datos y consigue
	 * la interfaz
	 */
	private static void getUserMapper() {
		session = MyBatisUtil.getSqlSessionFactory().openSession();
		userMapper = session.getMapper(UserMapper.class);
	}
	
	/**
	 * Cierra la conexion
	 */
	private static void closeAll() {
		session.close();
	}
	
	public User getUserByEmail(String email) {
		try {
			getUserMapper();
			return userMapper.getUserByEmail(email);
		} catch(Exception e) {
			LOG.logError(e.getMessage());
		} finally {
			try {
				closeAll();
			} catch (Exception e) {
				LOG.logError(e.getMessage());
			}
		}
		return null;
	}
	
	public void addUser(User usr) {
		try {
			getUserMapper();
			userMapper.addUser(usr);
			session.commit();
		} catch(Exception e) {
			LOG.logError(e.getMessage());
		} finally {
			try {
				closeAll();
			} catch (Exception e) {
				LOG.logError(e.getMessage());
			}
		}
	}
}