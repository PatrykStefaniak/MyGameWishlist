package mygamewishlist.model.pojo.db;

public class WishListGame {

	private String urlGame;
	private String urlStore;
	private int idList;
	private int idStore;
	private String gameName;
	private String img;
	private double defaultPrice;
	private double currentPrice;
	private double discount;
	private double minPrice;
	private double maxPrice;

	public WishListGame() {
		super();
	}

	public WishListGame(String urlGame, String urlStore, int idList, int idStore, String gameName, String img,
			double defaultPrice, double currentPrice, double discount, double minPrice, double maxPrice) {
		super();
		this.urlGame = urlGame;
		this.urlStore = urlStore;
		this.idList = idList;
		this.idStore = idStore;
		this.gameName = gameName;
		this.img = img;
		this.defaultPrice = defaultPrice;
		this.currentPrice = currentPrice;
		this.discount = discount;
		this.minPrice = minPrice;
		this.maxPrice = maxPrice;
	}

	public String getUrlGame() {
		return urlGame;
	}

	public void setUrlGame(String urlGame) {
		this.urlGame = urlGame;
	}

	public String getUrlStore() {
		return urlStore;
	}

	public void setUrlStore(String urlStore) {
		this.urlStore = urlStore;
	}

	public int getIdList() {
		return idList;
	}

	public void setIdList(int idList) {
		this.idList = idList;
	}

	public int getIdStore() {
		return idStore;
	}

	public void setIdStore(int idStore) {
		this.idStore = idStore;
	}

	public String getGameName() {
		return gameName;
	}

	public void setGameName(String gameName) {
		this.gameName = gameName;
	}

	public String getImg() {
		return img;
	}

	public void setImg(String img) {
		this.img = img;
	}

	public double getDefaultPrice() {
		return defaultPrice;
	}

	public void setDefaultPrice(double defaultPrice) {
		this.defaultPrice = defaultPrice;
	}

	public double getCurrentPrice() {
		return currentPrice;
	}

	public void setCurrentPrice(double currentPrice) {
		this.currentPrice = currentPrice;
	}

	public double getDiscount() {
		return discount;
	}

	public void setDiscount(double discount) {
		this.discount = discount;
	}

	public double getMinPrice() {
		return minPrice;
	}

	public void setMinPrice(double minPrice) {
		this.minPrice = minPrice;
	}

	public double getMaxPrice() {
		return maxPrice;
	}

	public void setMaxPrice(double maxPrice) {
		this.maxPrice = maxPrice;
	}

}
