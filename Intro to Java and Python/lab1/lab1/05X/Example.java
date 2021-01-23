import java.io.*;
import java.nio.file.*;
import java.util.*;

class Example{

	public static void main(String argv[])
	{
		int number_of_bins = 0;
		int smallest_number = 0;
		int bin_size = 0;
		if(argv.length !=4)
		{
			System.err.println("Please enter arguemnts in the following order: Name of file, number of bins, lowest number in smallest bin, number of integers in each bin.");
			System.exit(1);
		}
		try{
			number_of_bins = Integer.parseInt(argv[1]);
			smallest_number = Integer.parseInt(argv[2]);
			bin_size = Integer.parseInt(argv[3]);
		}
		catch(Exception e)
		{
			System.err.println("Unable to at least one argument.  Please only enter arguments in the following fashion: string, int, int, int");
			System.exit(1);
		}
		if(number_of_bins < 0 || bin_size < 0)
		{
			System.err.println("The second and fourth parameters must be positive.");
			System.exit(1);
		}
		try
		{
			Scanner scan = new Scanner(new File(argv[0]));
			int len = scan.nextInt();
			int[] numbers = new int[len];
                        int below_min = 0;
			int above_max = 0;
			for(int i = 0; i < len; i++)
			{
				numbers[i] = scan.nextInt();
				if(numbers[i] < smallest_number)
				{
					below_min++;
				}
				else if(numbers[i] >= (smallest_number+(number_of_bins*bin_size)))
				{
					above_max++;
				}
			}
			System.out.println("Values below "+smallest_number+":"+below_min);
			int in_the_bin = 0;
			for(int i = 0; i < number_of_bins;i++)
			{
				for(int j = 0; j < len; j++)
				{
					if(numbers[j] >= smallest_number && numbers[j] < smallest_number + bin_size)
					{
						in_the_bin++;
					}
				}
				System.out.println("Values between "+smallest_number+" and "+(smallest_number+bin_size)+": "+in_the_bin);
				smallest_number+=bin_size;
				in_the_bin =0;
			}
			System.out.println("Values above or equal to "+smallest_number+":"+above_max);
		}
		catch(Exception e)
		{

		}
	}

}
