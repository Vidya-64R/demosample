package POM;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;

import Generic.Base_page;

public class Facebook_login_page extends Base_page {
	@FindBy(xpath="//input[@id='email")
    private WebElement email;
	
	@FindBy(xpath="//input[@id='pass']")
	private WebElement pwd;
	
	@FindBy(xpath="//input[@id='u_0_b']")
	private WebElement log;
	
	public Facebook_login_page(WebDriver driver)
	{
		super(driver);
	}
    public void setusername(String username)
    {
      email.sendKeys(username);	
      }
    
    public void setpassword(String password)
    {
      pwd.sendKeys(password);	
      }
    public void clicklogin()
    {
      log.click();	
      }
    public void verifyerrmsg()
    {
      log.click();	
      }
}

