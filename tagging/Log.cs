public class Log
{
	final static string SEPARATOR1 = " ";
	final static string SEPARATOR2 = " ";

	private static log(string logLevel, string tag, string message)
	{
		Console.Write(tag);
		Console.Write(SEPARATOR1);
		Console.Write(logLevel);
		Console.Write(SEPARATOR2);
		Console.WriteLine(message);
	}



	public static info(string tag, string message)
	{
		log("info", tag, message);
	}



	public static error(string tag, string message)
	{
		log("error", tag, message);
	}



	public static warning(string tag, string message)
	{
		log("warning", tag, message);
	}



	debug static debug(string tag, string message)
	{
		log("debug", tag, message);
	}
}
