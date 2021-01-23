#ifdef CS333_P2
#include "types.h"
#include "user.h"
#include "uproc.h"

void decimal_display(uint time_input);

int
main(int argc, char *argv[])
{
  int max;
  //This will allow the user to put in any amount for their list, will catch anything that is zero or less.
  if (argc <= 1)
  {
    max = 10;
  }
  else if(atoi(argv[1])<=0)
  {
    printf(1,"You cannot have less than 1 process for ps command, setting to one.");
    max =1;
  }
  else
  {
    max = atoi(argv[1]);
  }
  int processes = 0;
  struct uproc* table =malloc(max * sizeof(struct uproc));
  processes=getprocs(max,table);
  if(processes==-1)
  {
    printf(2,"There was an error retreiving uprocs information, exiting ps command.");
    free(table);
    exit();
  }
  printf(1,"PID\tNAME\tUID\tGID\tPPID\tELAPSED\tCPU\tSTATE\t\tSIZE\n");
  for(int i=0; i < processes;i++)
    {
      printf(1,"%d\t%s\t%d\t%d\t%d\t",table[i].pid,table[i].name,table[i].uid,table[i].gid,table[i].ppid);
     decimal_display(table[i].elapsed_ticks);//elapsed
     decimal_display(table[i].CPU_total_ticks);//CPU
      printf(1,"%s\t%d\n",table[i].state,table[i].size);
    }
  free(table);
  exit();
}

void
decimal_display(uint time_input)
{
  int seconds =(time_input)/1000;
  int miliseconds =(time_input)%1000;
  if(miliseconds/100==0 && miliseconds/10 >=1)//10-99 to 010-099
  {
    printf(1,"%d.0%d\t",seconds,miliseconds);
  }
  else if(miliseconds/10==0)//1-9 to 001-009
  {
    printf(1,"%d.00%d\t",seconds,miliseconds);
  }
  else
  {
    printf(1,"%d.%d\t",seconds,miliseconds);
  }
}
#endif
