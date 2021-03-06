package mygamewishlist.model.dao.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import mygamewishlist.model.pojo.SteamGame;

public interface SteamMapper {

	public ArrayList<Integer> getSteamGameIdsByName(@Param("name") String name);
	
	public void addGame(SteamGame sg);
	
	public void deleteSteamGameById(@Param("id") int id);
}
