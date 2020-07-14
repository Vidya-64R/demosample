package Pepperfry_page;

import java.util.Set;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

public class Flowers_vases_ppf_page extends Base_page{
	@FindBy(xpath="//div[@data-pid='1814417']")
	private WebElement vasebrown;
	
	public Flowers_vases_ppf_page(WebDriver driver) 
	{
		super(driver);
	}
	
	public void clickvasesb()
	{
		clickableElement(5, vasebrown);
		vasebrown.click();
		
		Set<String>allwindow=driver.getWindowHandles();
    	for(String str:allwindow)
    	{
    		driver.switchTo().window(str);
    	}
	}
}
