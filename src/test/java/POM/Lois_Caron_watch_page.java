package POM;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import Generic.Base_page;

public class Lois_Caron_watch_page extends Base_page{
		@FindBy(xpath="//button[contains(.,'ADD TO CART')]")
	    private WebElement addtocart;
		
		public Lois_Caron_watch_page(WebDriver driver)
		{
			super(driver);
		}
	    public void clickadd2cart()
	    {
	    	clickableElement(5,addtocart );
	    	addtocart.click();
	    }
}

