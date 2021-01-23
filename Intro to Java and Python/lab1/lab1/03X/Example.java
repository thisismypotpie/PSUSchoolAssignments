class Example{
	public static void main(String argv[])
	{
		int n =0;
		if(argv.length !=1)
		{
			System.err.println("Please enter only one argument.  That argument must be an integer.");
			System.exit(1);
		}
		try{
			n = Integer.parseInt(argv[0]);
		}
		catch(Exception e)
		{
			System.err.println("Unable to parse argument.  Please enter only an integer.");
			System.exit(1);
		}
		if(n <=0)
		{
			System.err.println("Please only enter a positive number.");
			System.exit(1);
		}
		for(int i=1; i <= n; i++)
		{
			if(i%3 ==0 && i % 5 ==0)
			{
				System.out.println("FlimFlam");
			}
			else if(i % 3 ==0)
			{
				System.out.println("Flim");
			}
			else if(i % 5 == 0)
			{
				System.out.println("Flam");
			}
			else
			{
				System.out.println(i);
			}
		}
	}

}
