package Pepperfry_page;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

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
	}
    catch(Exception e)
    {
    	System.out.println("failed to locate element");
    }
	}
public void clickableElement(int time,WebElement element)
{
	WebDriverWait wait=new WebDriverWait(driver,time);
try
{
	wait.until(ExpectedConditions.elementToBeClickable(element));
}
catch(Exception e)
{
	System.out.println("failed to click element");
}
}
public void verifyTitle(int time,String title)
{
	WebDriverWait wait=new WebDriverWait(driver,time);
	try
	{
		wait.until(ExpectedConditions.titleContains(title));
	}
	catch(Exception e)
	{
		System.out.println("title not displayed");
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
public void alert(WebDriver driver, int time)
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
public void noofwindows(WebDriver driver, int time, int count)
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
