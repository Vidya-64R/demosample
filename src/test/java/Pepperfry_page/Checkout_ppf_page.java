package Pepperfry_page;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class Checkout_ppf_page extends Base_page{
	@FindBy(xpath="//a[.='GO TO CART']")
	private WebElement gotocart;
	
	public Checkout_ppf_page(WebDriver driver) 
	{
		super(driver);
	}
	
	public void go2cart()
	{
		clickableElement(5, gotocart);
		gotocart.click();
	}
}
