package Generic;

import java.io.FileInputStream;
import java.util.Properties;
import org.testng.Reporter;

public class Filemanager {
Properties pro;

public Filemanager()
{
	try
	{
		FileInputStream fis=new FileInputStream("./configuration.properties");
		pro=new Properties();
		pro.load(fis);
	}
	catch(Exception e)
	{
		Reporter.log("property file not found",true);
	}
}
public String getaurl()
{
	String url=pro.getProperty("aurl");
	if(url==null)
		
		throw new RuntimeException("url not found");
	return url;
	}
public String getfurl()
{
	String url=pro.getProperty("furl");
	if(url==null)
		
		throw new RuntimeException("url not found");
	return url;
	}
public String getpurl()
{
	String url=pro.getProperty("purl");
	if(url==null)
		
		throw new RuntimeException("url not found");
	return url;
	}
}
