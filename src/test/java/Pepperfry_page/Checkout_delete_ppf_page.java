package Pepperfry_page;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class Checkout_delete_ppf_page extends Base_page{
	@FindBy(xpath="//a[@class='trash']")
	private WebElement remove;
	
	public Checkout_delete_ppf_page(WebDriver driver) 
	{
		super(driver);
	}
	
	public void trash()
	{
		clickableElement(5, remove);
		remove.click();
}
}
