package Generic;
import java.io.File;
import java.util.Date;

	import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.io.FileHandler;
import org.testng.Reporter;

	public class Screenshot {
	public String capture(WebDriver driver, String tc_name)
	{
	Date d=new Date();
	String d1=d.toString();
	String date = d1.replace(":", "-");
	
	String path=System.getProperty("user.dir")+ "./photos/"+date+tc_name+".png";
	
	
	TakesScreenshot ts=(TakesScreenshot)driver;
	File src = ts.getScreenshotAs(OutputType.FILE);
	File dest= new File(path+date+tc_name+".jpg");
	try
	{
		FileHandler.copy(src, dest);
		}
	catch(Exception e)
	{
	Reporter.log("failed to take screenshot",true);	
	}
	return path;
}
}
             