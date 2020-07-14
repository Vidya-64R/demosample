package POM;

import java.util.Set;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import Generic.Base_page;

public class Watchesforwomen_page extends Base_page{
	@FindBy(xpath="//div[@data-id='SMWFZWXZYYKWH4CY']")
    private WebElement watch1;
	
	@FindBy(xpath="//div[@data-id='SMWFZWXZYYKWH4CY']")
    private WebElement watch2;
	
	@FindBy(xpath="//div[@data-id='SMWF52NKUWQ4FH4C']")
    private WebElement watch3;
	
	@FindBy(xpath="//div[@data-id='SMWFHFZEYBB2ANZZ']")
    private WebElement watch4;
	
	public Watchesforwomen_page(WebDriver driver)
	{
		super(driver);
	}
    public void clickwatch1()
    {
    	clickableElement(5,watch1);
    	watch1.click();
    	
    	Set<String>allwindow=driver.getWindowHandles();
    	for(String str:allwindow)
    	{
    		driver.switchTo().window(str);
    	}
    }
    
    public void clickwatch2()
    {
    	clickableElement(5,watch2 );
    	watch2.click();
    	Set<String>allwindow=driver.getWindowHandles();
    	for(String str:allwindow)
    	{
    		driver.switchTo().window(str);
    	}
    }
    
    public void clickwatch3()
    {
    	clickableElement(5,watch3 );
    	watch3.click();
    	Set<String>allwindow=driver.getWindowHandles();
    	for(String str:allwindow)
    	{
    		driver.switchTo().window(str);
    	}
    }
    
    public void clickwatch4()
    {
    	clickableElement(5,watch4 );
    	watch4.click();
    	Set<String>allwindow=driver.getWindowHandles();
    	for(String str:allwindow)
    	{
    		driver.switchTo().window(str);
    	}
    }
}


