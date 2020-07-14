package POM;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;

import Generic.Base_page;

public class Online_Shopping_page extends Base_page{

	@FindBy(xpath="//button[.='✕']")
    private WebElement cancel;
	
	@FindBy(xpath="//span[.='Women']")
	private WebElement women;
	
	@FindBy(xpath="(//a[.='Smart Watches'])[3]")
	private WebElement watches;
	
	public Online_Shopping_page(WebDriver driver)
	{
		super(driver);
	}
    public void clickcancel()
    {
      clickableElement(5,cancel);
    	cancel.click();
    }
    public void mouseoveronwomen()
    {
    	verifyElement(5, women);
    	new Actions(driver).moveToElement(women).perform();
    }
    public void clickwatches()
    {
    	clickableElement(5, watches);
    	watches.click();
    }
}
