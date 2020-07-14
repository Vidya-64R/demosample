package regressionscripts;


import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

import POM.Online_Shopping_page;
import POM.login_page;
import Generic.Dataprovider;
import Generic.Generic_test;

public class Flipkart_testclass extends Generic_test
{
	@Test(dataProvider="testdata")
	
	public void login4(String email1, String password1) throws InterruptedException 
	{
		test=reports.createTest("flipkart_login", "user entered valid cred");
		test.info("flipkart test started");
				
	   login_page lnp=new login_page(driver);
	   lnp.setemailid(email1);
	   test.pass("user succesfully entered emailid");
	   
       lnp.setpassword(password1);	
       test.pass("user succesfully entered password");
       
       lnp.clicklogin();
       test.pass("user succesfully clicked on login");
      
       Online_Shopping_page shop=new Online_Shopping_page(driver);
	    shop.clickcancel();
	    shop.mouseoveronwomen();
	    shop.clickwatches();
	    test.info("flipkart test ended");
       
       //String atitle=driver.getTitle();
		//Assert.assertEquals(atitle, "Online Shopping Site for Mobiles,");
		//test.pass("title has been verified");
       
	}  
       @DataProvider(name="testdata")
       public Object[][] getData()
   	{
   		Object[][] arrobj=Dataprovider.Getdata("Sheet1");
   		return arrobj;
       }
}
