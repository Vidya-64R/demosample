package Pepperfry_page;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;

public class Online_Furniture_Shopping_page extends Base_page{
	@FindBy(xpath="//a[.='Decor']")
	private WebElement decor;
	
	@FindBy(xpath="(//a[.='Vases'])[2]")
	private WebElement vases;
	
		public Online_Furniture_Shopping_page(WebDriver driver) 
		{
			super(driver);
		}
		public void clickabledecor()
		{
			verifyElement(5, decor);
			new Actions(driver).moveToElement(decor).perform();
		}
		public void clickvases()
		{
			clickableElement(5, vases);
			vases.click();
		}
		}
 
