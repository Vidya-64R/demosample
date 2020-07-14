package Generic;

import java.io.IOException;
import java.util.Date;
import org.apache.log4j.Logger;
import org.openqa.selenium.WebDriver;
import org.testng.ITestResult;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.AfterSuite;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.BeforeSuite;
import org.testng.annotations.Optional;
import org.testng.annotations.Parameters;

import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.ExtentTest;
import com.aventstack.extentreports.MediaEntityBuilder;
import com.aventstack.extentreports.reporter.ExtentHtmlReporter;

public class Generic_test {
	public WebDriver driver;
	public static ExtentHtmlReporter htmlreporter;
	public static ExtentReports reports;
	public static ExtentTest test;
	
   public Logger log=Logger.getLogger(Generic_test.class);
	
	
	BrowserFactory bff=new BrowserFactory();
	Filemanager fm=new Filemanager();
	
	@BeforeSuite
	public void setup()
	{
		htmlreporter =new ExtentHtmlReporter("./Ereports/"+new Date().toString().replace(":","-")+".html");//need to specify report generation
		reports=new ExtentReports();
		reports.attachReporter(htmlreporter);
	}
	
	@Parameters({"browser"})
	@BeforeMethod
	public void openAppn(@Optional("chrome")String browser)
	{
		System.out.println("the browser name is"+browser);
		log.info("browser is launched");
		if(browser.equals("chrome"))
		{
		driver=bff.getbrowser("chrome");
		driver.get(fm.getaurl());
	}
		else
		{
			driver=bff.getbrowser("firefox");
			driver.get(fm.getfurl());
		}
		//driver.manage().timeouts().implicitlyWait(fm.getimpllicitlyWait(), TimeUnit.SECONDS)
		
	}
	@AfterMethod
	public void closeAppn(ITestResult res) throws IOException
	{
		
		System.out.println(res.getStatus());
		if(ITestResult.FAILURE==res.getStatus())
		{
			String tc_name=res.getName();
			//Screenshot.capture(driver,tc_name);
			test.fail("testcase failed", MediaEntityBuilder.createScreenCaptureFromPath(new Screenshot().capture(driver, tc_name)).build());
		}
		
		test.assignAuthor("vidya");
		test.assignDevice("laptop");
		test.assignCategory("gui automation");
		reports.setSystemInfo("windows", "10");
		driver.quit();
		log.info("browser is closed");
	}
	@AfterSuite
	public void tearDown()
	{
		reports.flush();
	}
}
