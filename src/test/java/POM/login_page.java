package POM;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import Generic.Base_page;

public class login_page extends Base_page{

		@FindBy(xpath="//input[@class='_2zrpKA _1dBPDZ']")
	    private WebElement email123;
		
		@FindBy(xpath="//input[@class='_2zrpKA _3v41xv _1dBPDZ']")
		private WebElement pwd;
		
		@FindBy(xpath="//button[@class='_2AkmmA _1LctnI _7UHT_c']")
		private WebElement login;
		
		public login_page(WebDriver driver)
		{
			super(driver);
		}
	    public void setemailid(String emailid)
	    {
	      email123.sendKeys(emailid);	
	      }
	    
	    public void setpassword(String password2)
	    {
	      pwd.sendKeys(password2);	
	      }
	    public void clicklogin()
	    {
	      login.click();	
	      }
	}

	
