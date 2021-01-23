#ifdef CS333_P2
#include "types.h"
#include "user.h"

void time_display(uint time_input, char* name);
//void get_times(int current_it, int its_left, char** args);

int
main(int argc, char *argv[])
{
  int start;
  int finish;
  int pid;
  int process_name = 1;
  //int return_code = 0;
  start = uptime();
  pid = fork();
  if(pid ==0)
  {
    ++argv;
    ++process_name;
    exec(argv[0],argv);
  }
  else
  {
   /*return_code =*/wait();
   //printf(1,"Return code: %d",return_code);
    /*if(return_code !=0)
    {
      printf(1,"ERROR: Process/command unknown.\n");
      exit();
    }*/
    finish = uptime();
    time_display(finish-start,argv[process_name]);
  }
  exit();
}

/*void
get_times(int current_it, int its_left, char** args)
{
  printf(1,"iteration: %d. Its left: %d\n",current_it,its_left);
  int start=0;
  int finish=0;
  char* process_name = args[current_it];
  printf(1,"Process name: %s\n",process_name);
  if(its_left<=0)
  {
    printf(1,"Base case reached!\n");
    return;
  }
  start = uptime();
  fork();
  exec(args[current_it],args+1);
  wait();
  finish = uptime();
  get_times(++current_it,--its_left,args);
  time_display(finish-start,process_name);
  printf(1,"popping on int: %d\n",current_it);
}*/

void
time_display(uint time_input, char* name)
{
  int seconds =(time_input)/1000;
  int miliseconds =(time_input)%1000;
  if(miliseconds/100==0 && miliseconds/10 >=1)//10-99 to 010-099
  {
    printf(1,"Process %s ran in %d.0%d seconds.\n",name,seconds,miliseconds);
//    printf(2,"%d.0%d\t",seconds,miliseconds);
  }
  else if(miliseconds/10==0)//1-9 to 001-009
  {
    printf(1,"Process %s ran in %d.00%d seconds.\n",name,seconds,miliseconds);
  //  printf(1,"%d.00%d\t",seconds,miliseconds);
  }
  else
  {
    printf(1,"Process %s ran in %d.%d seconds.\n",name,seconds,miliseconds);
  }
}
#endif

