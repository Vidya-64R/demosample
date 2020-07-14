package Pepperfry_page;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.annotations.Test;

public class pepperfry_mainclass {
	@Test
public void login3() {
		System.setProperty("webdriver.chrome.driver","./softwares/chromedriver.exe");
		WebDriver driver=new ChromeDriver();
		driver.manage().window().maximize();
		driver.get("https://www.pepperfry.com");
		
		Online_Furniture_Shopping_page lp=new Online_Furniture_Shopping_page(driver);
	    lp.clickabledecor();
	    lp.clickvases();
	    
	    Flowers_vases_ppf_page vp=new Flowers_vases_ppf_page(driver);
	    vp.clickvasesb();
	    
	    Add2cart_ppf_page ap= new Add2cart_ppf_page(driver);
	    ap.add2cart();
	    
	    Checkout_ppf_page gp=new Checkout_ppf_page(driver);
	    gp.go2cart();
	    
	    Checkout_delete_ppf_page dp=new Checkout_delete_ppf_page(driver);
	    dp.trash();
	    
	    emptycart_ppf_page ecp=new emptycart_ppf_page(driver);
	    ecp.emptycart();
	    }
	}
