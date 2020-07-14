package regressionscripts;

import org.testng.Assert;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;
import Generic.Dataprovider;
import Generic.Generic_test;
import POM.Facebook_login_page;

public class Fb_testclass extends Generic_test{
	@Test(dataProvider="authentication")
	public void login(String username, String password)
	{
		Facebook_login_page fb=new Facebook_login_page(driver);
		fb.setusername(username);
		fb.setpassword(password);
		fb.clicklogin();
		String atitle=driver.getTitle();
		Assert.assertEquals(atitle, "Facebook-log in or sign up");
	}
	@DataProvider(name="authentication")
	//@DataProvider()
	public Object[][] getData()
	{
		Object[][] arrobj=Dataprovider.Getdata("sheet1");
		return arrobj;
	}
}
