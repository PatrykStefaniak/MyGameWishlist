package mygamewishlist.model.dao;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;

import mygamewishlist.model.dao.mapper.TimelineMapper;
import mygamewishlist.model.pojo.MyLogger;
import mygamewishlist.model.pojo.ScrapedGame;
import mygamewishlist.model.pojo.db.TimelineGame;
import mygamewishlist.model.pojo.db.TimelineGameDetailed;

/**
 * @author Patryk
 *
 * Class that gets the Timeline interface, and gets
 * the database conection
 */
public class TimelineDAO {

	private static final MyLogger LOG = MyLogger.getLOG();
	private static SqlSession session;
	private static TimelineMapper timelineMapper;
	
	/**
	 * Creates conection with the database, and gets the interface
	 */
	private static void getTimeMapper() {
		session = MyBatisUtil.getSqlSessionFactory().openSession();
		timelineMapper = session.getMapper(TimelineMapper.class);
	}
	
	/**
	 * Closes the conection
	 */
	private static void closeAll() {
		session.close();
	}
		
	public void add2Timeline(ScrapedGame sg, String time, int idUrl) {
		try {
			getTimeMapper();
			timelineMapper.add2Timeline(sg, time, idUrl);
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
	
	public ArrayList<TimelineGame> getTimelineByUrl(String url) {
		try {
			getTimeMapper();
			return timelineMapper.getTimelineByUrl(url);
		} catch(Exception e) {
			LOG.logError(e.getMessage());
		} finally {
			try {
				closeAll();
			} catch (Exception e) {
				LOG.logError(e.getMessage());
			}
		}
		return new ArrayList<TimelineGame>();
	}
	
	public ArrayList<TimelineGameDetailed> getTimelineByUrlDetailed(String url) {
		try {
			getTimeMapper();
			return timelineMapper.getTimelineByUrlDetailed(url);
		} catch(Exception e) {
			LOG.logError(e.getMessage());
		} finally {
			try {
				closeAll();
			} catch (Exception e) {
				LOG.logError(e.getMessage());
			}
		}
		return new ArrayList<TimelineGameDetailed>();
	}
}
