package Pepperfry_page;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class Add2cart_ppf_page extends Base_page{
	@FindBy(xpath="//a[.='ADD TO CART']")
    private WebElement addtocart;
	
	public Add2cart_ppf_page(WebDriver driver) 
	{
		super(driver);
	}
	public void add2cart()
	{
	    clickableElement(5, addtocart);
		addtocart.click();
	}
}
