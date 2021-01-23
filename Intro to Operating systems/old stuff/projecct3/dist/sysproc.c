#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#ifdef PDX_XV6
#include "pdx-kernel.h"
#endif // PDX_XV6
#ifdef CS333_P2
#include "uproc.h"
#endif

#ifdef CS333_P2
int  populateprocs(uint max,struct uproc* table);
#endif

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  xticks = ticks;
  return xticks;
}

#ifdef PDX_XV6
// Turn off the computer
int
sys_halt(void)
{
  cprintf("Shutting down ...\n");
  outw( 0x604, 0x0 | 0x2000);
  return 0;
}
#endif // PDX_XV6

#ifdef CS333_P1
int
sys_date(void)
{
  struct rtcdate *d;

 if(argptr(0, (void*)&d, sizeof(struct rtcdate)) < 0)
   return -1;
 cmostime(d);
 return 0;
}
#endif

#ifdef CS333_P2
int
sys_getuid(void)
{
  cprintf("%s","UID: ");
  return myproc()->uid;
}

int
sys_getgid(void)
{
  cprintf("%s","GID: ");
  return myproc()->gid;
}

int
sys_getppid(void)
{
  if(myproc()->parent->pid == NULL)
  {
    cprintf("%s","PPID is null, returning PID instead.");
    return myproc()->pid;
  }
  return myproc()->parent->pid;
}

int
sys_setuid(void)
{
  int arg;
  if(argint(0,&arg)<0)
  return -1;
//  cprintf("%s%d\n","arg is: ",arg);
  if(arg < 0 || arg > 32767)
    {
      cprintf("%s","UID input is invalid.\n");
      return -1;
    }
  myproc()->uid= arg;
  cprintf("%s%d\n","UID set to:  ",myproc()->uid);
  return 0;
}

int
sys_setgid(void)
{
  int arg;
  if(argint(0,&arg)<0)
  return -1;
//  cprintf("%s%d\n","arg is: ",arg);
  if(arg < 0 || arg > 32767)
    {
      cprintf("%s","GID input is invalid.\n");
      return -1;
    }
  myproc()->gid= arg;
  cprintf("%s%d\n","GID set to:  ",myproc()->gid);
  return 0;
}

int
sys_getprocs(void)
{
  struct uproc* table;
  int max;
 // int processes=0;
  if(argint(0,&max)<0)
    return -1;
  if(argptr(1, (void*)&table, sizeof(struct uproc)*max) < 0)
    return -1;
 // processes = populateprocs(max,table);
  /*cprintf("PID\tNAME\tUID\tGID\tPPID\tELAPSED\tCPU\tSTATE\t\tSIZE\n");
  for(int i=0; i < processes;i++)
    {
      cprintf("%d\t%s\t%d\t%d\t%d\t%d\t%d\t%s\t%d\n",table[i].pid,table[i].name,table[i].uid,table[i].gid,table[i].ppid,table[i].elapsed_ticks,table[i].CPU_total_ticks,table[i].state,table[i].size);
    }*/
  return populateprocs(max,table);
}
#endif
