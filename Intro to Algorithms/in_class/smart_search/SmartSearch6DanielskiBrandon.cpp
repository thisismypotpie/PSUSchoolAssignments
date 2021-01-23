#include <iostream>
#include <cstring>
using namespace std;


int smart_search(string text, string pattern)
{
	int m = pattern.length();
	int ascii_table[255];
	int text_index = 0;
	int pattern_index = m-1;
	int temp = 0;
	for(int i=0; i < 255;i++)
	{
		ascii_table[i] = m;
	}
	while (pattern_index> 0)
	{
		ascii_table[(int)pattern[text_index]+1] = pattern_index;
		cout <<"Giving value: "<<(char)(pattern[text_index])<< " a value of "<<ascii_table[(int)pattern[text_index]+1]<<"."<<endl;
		pattern_index --;
		text_index++;
	}
	text_index = m-1;
	pattern_index = m-1;
	cout <<"Giving value: "<<(char)(pattern[m-1]) << " a value of "<<m<<"."<<endl;
	//cin.get();
	while(1==1)
	{
		if(text_index > text.length())
		{
			return -1;
		}
		else
		{
			cout<<"Starting text_index at: "<<text_index<<endl;
			//cin.get();
			temp = text_index;
			while((int)pattern[pattern_index] == (int)text[text_index])
			{
				cout <<pattern[pattern_index]<<" and "<<text[text_index]<<" match!"<<endl;
				if(pattern_index==0)
				{
					cout<<"MATCH FOUND: ";
					for(int i = text_index; i < (text_index + m);i++)
					{
						cout<<text[i];
					}
					cout<<endl;
					return text_index;
				}
				else
				{
					pattern_index --;
					text_index --;
				}
			}
			cout <<pattern[pattern_index]<<" and "<<text[text_index]<<" don't match."<<endl;
			//cin.get();
			text_index = temp;
			cout <<"Shifting text index :"<< ascii_table[(int)text[text_index]+1]<<" slots."<<endl;
			//cin.get();
			text_index = text_index + ascii_table[(int)text[text_index]+1];
			pattern_index = m-1;
		}
	}


}

int main()
{
	int result = 0;
	int loop = 0;
	string pattern = "";
	string text = "";
	cin>>loop;
	cin.get();
	cout<<"Loop: "<<loop<<endl;
	getline(cin,pattern);
	cout <<"Pattern: "<<pattern<<endl;
	for(int i=0; i < loop;i++)
	{
		getline(cin,text);
		cout <<"Text: "<<text<<endl;
		result = smart_search(text,pattern);
		if(result == -1)
		{
			cout <<"No result found."<<endl;
		}
		else
		{
			cout<<"Result found starting at index: "<<result<<endl;
		}

	}
	return 0;
}
