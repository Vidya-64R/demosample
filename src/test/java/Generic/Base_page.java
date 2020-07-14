package Generic;


import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import org.testng.Reporter;

public abstract class Base_page {
	public WebDriver driver;
	 
	public Base_page(WebDriver driver)
	{
		this.driver=driver;
		PageFactory.initElements(driver, this);
	}
	
	
	public void verifyElement(int time,WebElement element)
	{
		WebDriverWait wait=new WebDriverWait(driver,time);
	try
	{
		wait.until(ExpectedConditions.visibilityOf(element));
		Reporter.log("element located", true);
	}
    catch(Exception e)
    {
    	Reporter.log("failed to locate element", true);
    	Assert.fail();
    }
	}
public void clickableElement(int time,WebElement element)
{
	WebDriverWait wait=new WebDriverWait(driver,time);
try
{
	wait.until(ExpectedConditions.elementToBeClickable(element));
	Reporter.log("element clicked", true);
}
catch(Exception e)
{
	Reporter.log("failed to click element", true);
	Assert.fail();
}
}
public void verifyTitle(int time,String title)
{
	WebDriverWait wait=new WebDriverWait(driver,time);
	try
	{
		wait.until(ExpectedConditions.titleContains(title));
		Reporter.log("title displayed", true);
	}
	catch(Exception e)
	{
		Reporter.log("title not displayed", true);
		Assert.fail();
	}
	}
public void switchtoframe(int time,String page)
{
	WebDriverWait wait=new WebDriverWait(driver,time);
	try
	{
		wait.until(ExpectedConditions.frameToBeAvailableAndSwitchToIt(page));
	}
	catch(Exception e)
	{
		System.out.println("frame not available");
	}
	}
public void alert(int time)
{
	WebDriverWait wait=new WebDriverWait(driver,time);
	try
	{
		wait.until(ExpectedConditions.alertIsPresent());
	}
	catch(Exception e)
	{
		System.out.println("alert not present");
	}
	}
public void noofwindows(int time, int count)
{
	WebDriverWait wait=new WebDriverWait(driver,time);
	try
	{
		wait.until(ExpectedConditions.numberOfWindowsToBe(count));
	}
	catch(Exception e)
	{
		System.out.println("no of windows not displayed");
	}
	}
public void elementpresence(int time, By locator)
{
	WebDriverWait wait=new WebDriverWait(driver,time);
	try
	{
		wait.until(ExpectedConditions.presenceOfElementLocated(locator));
	}
	catch(Exception e)
	{
		System.out.println("element not located");
	}
	}

	

}
