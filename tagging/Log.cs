public static class Log
{
	const string SEPARATOR1 = " ";
	const string SEPARATOR2 = " ";

	private static void log(string logLevel, string tag, string message)
	{
		System.Console.Write(tag);
		System.Console.Write(SEPARATOR1);
		System.Console.Write(logLevel);
		System.Console.Write(SEPARATOR2);
		System.Console.WriteLine(message);
	}



	public static void info(string tag, string message)
	{
		log("info", tag, message);
	}



	public static void error(string tag, string message)
	{
		log("error", tag, message);
	}



	public static void warning(string tag, string message)
	{
		log("warning", tag, message);
	}



	public static void debug(string tag, string message)
	{
		log("debug", tag, message);
	}
}
