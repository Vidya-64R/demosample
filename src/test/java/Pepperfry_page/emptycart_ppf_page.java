package Pepperfry_page;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class emptycart_ppf_page extends Base_page {
	@FindBy(xpath="//span[.='Your Shopping Cart Is Empty']")
	private WebElement cart;
	
	public emptycart_ppf_page(WebDriver driver) 
	{
		super(driver);
	}
	
	public void emptycart()
	{
	    clickableElement(5, cart);
		cart.click();
	}
}
