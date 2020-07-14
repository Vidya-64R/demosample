package regressionscripts;

import org.testng.Assert;
import org.testng.annotations.Test;

import Generic.Excel;
import Generic.Generic_test;
import POM.login_page;

public class Invalidlogin extends Generic_test{
	@Test
	public void invalidlogin()
	{
		String emailid=Excel.getData("sheet1",1,1);
		String password2=Excel.getData("sheet1",1,1);
		//String etitle=Excel.getData("sheet1", 1, 3);                
		
		test.info("invalid test has started");
		login_page lp=new login_page(driver);
		lp.setemailid(emailid);
		 test.pass("user succesfully entered emailid");
		 
		lp.setpassword(password2);
		 test.pass("user succesfully entered password");
		 
		lp.clicklogin();
		 test.pass("user succesfully clicked on login");
		 
		lp.verifyTitle(5, "flipkart");
		 test.pass("error message dispalyed");
		
		String atitle=driver.getTitle();
		Assert.assertEquals(atitle, "Online Shopping Site for Mobiles,");
		 test.pass("title verified successfully");
		 test.info("test ended");
	}

}
