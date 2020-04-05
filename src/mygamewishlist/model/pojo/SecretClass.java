package mygamewishlist.model.pojo;

import javax.ejb.EJB;

import mygamewishlist.model.ejb.CreateQueryEJB;

public class SecretClass {

	private static SecretClass sc;
	
	@EJB
	CreateQueryEJB cq_ejb;
	
	private SecretClass() {
		if (cq_ejb == null) {
			cq_ejb = new CreateQueryEJB();
		}
		mailPasswd = cq_ejb.getVariable("emailPasswd");
		steamToken = cq_ejb.getVariable("steamToken");
	}
	
	public static SecretClass getSC() {
		if (sc == null) {
			synchronized (SecretClass.class) {
				if (sc == null) {
					sc = new SecretClass();
				}
			}
		}
		return sc;
	}
	
	public String mailPasswd;
	public String steamToken;
}
