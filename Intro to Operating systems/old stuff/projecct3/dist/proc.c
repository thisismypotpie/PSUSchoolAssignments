#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#ifdef CS333_P2
#include "uproc.h"
#endif
// list management function prototypes
#ifdef CS333_P3
struct ptrs {
  struct proc* head;
  struct proc* tail;
};
static void initProcessLists(void);
static void initFreeList(void);
static void assertState(struct proc* list, enum procstate);
static void stateListAdd(struct ptrs*list , struct proc*);
static int  stateListRemove(struct ptrs*list, struct proc* p);
//static void promoteAll();
#endif

static char *states[] = {
[UNUSED]    "unused",
[EMBRYO]    "embryo",
[SLEEPING]  "sleep ",
[RUNNABLE]  "runble",
[RUNNING]   "run   ",
[ZOMBIE]    "zombie"
};

#ifdef CS333_P1
void	procdump_P1_Helper(struct proc *p);
int     P1_display(struct proc *p,char* state);
#endif
#ifdef CS333_P2
int   populateprocs(uint max,struct uproc* table);
void  time_display(uint time_input);
int   P2_display(struct proc *p,char* state);
#endif
#define statecount NELEM(states)
//#endif
static struct {
  struct spinlock lock;
  struct proc proc[NPROC];
#ifdef CS333_P3
  struct ptrs list[statecount];
#endif
} ptable;

static struct proc *initproc;

uint nextpid = 1;
extern void forkret(void);
extern void trapret(void);
static void wakeup1(void* chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;

  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid) {
      return &cpus[i];
    }
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
#ifdef CS333_P3
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  int found = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED) {
      found = 1;
      break;
    }
  if (!found) {
    release(&ptable.lock);
    return 0;
  }
  #ifdef CS333_P3
  //unused to embryo
  //1.Lock acquired in line 119.
  /*2.*/stateListRemove(&ptable.list[p->state],p);
  /*3.*/assertState(p, UNUSED);
  /*4.Was here before changes*/ p->state = EMBRYO;
  /*5.*/stateListAdd(&ptable.list[p->state],p);
  p->pid = nextpid++;
  /*6. Was here before changes*/release(&ptable.lock);
  #else
  p->state = EMBRYO;
  release(&ptable.lock);
  #endif

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    #ifdef CS333_P3
    //embryo to unused
    /*1.*/acquire(&ptable.lock);
    /*2.*/stateListRemove(&ptable.list[p->state],p);
    /*3.*/assertState(p, EMBRYO);
    /*4. Was here before changes*/p->state = UNUSED;
    /*5.*/stateListAdd(&ptable.list[p->state],p);
    /*6.*/release(&ptable.lock);
    #else
    p->state = UNUSED;
    #endif
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  #ifdef CS333_P1
  p->start_ticks = ticks;
  #endif
  #ifdef CS333_P2
  p->cpu_ticks_total = 0;
  p->cpu_ticks_in = 0;
  #endif
  return p;
}
#else
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  int found = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED) {
      found = 1;
      break;
    }
  if (!found) {
    release(&ptable.lock);
    return 0;
  }
  p->state = EMBRYO;
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  #ifdef CS333_P1
  p->start_ticks = ticks;
  #endif
  #ifdef CS333_P2
  p->cpu_ticks_total = 0;
  p->cpu_ticks_in = 0;
  #endif
  return p;
}
#endif
// Set up first user process.
#ifdef CS333_P3
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
#ifdef CS333_P3
  acquire(&ptable.lock);
 initProcessLists();
 initFreeList();
 release(&ptable.lock);
#endif
  p = allocproc();

  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
  #ifdef CS333_P3
  //embryo to runnable.
  /*1. lock acquired in line 265.*/
  /*2.*/stateListRemove(&ptable.list[p->state],p);
  /*3.*/assertState(p,EMBRYO);
  /*4. was here before changes*/p->state = RUNNABLE;
  /*5.*/stateListAdd(&ptable.list[p->state],p);
  /*6. lock released in line 277.*/
  #else
  p->state = RUNNABLE;
  #endif
  #ifdef CS333_P2
  p->uid = 0;
  p->gid = 0;
  #endif
  release(&ptable.lock);
}
#else
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
#ifdef CS333_P3
  acquire(&ptable.lock);
 initProcessLists();
 initFreeList();
 release(&ptable.lock);
#endif
  p = allocproc();

  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
  p->state = RUNNABLE;
  #ifdef CS333_P2
  p->uid = 0;
  p->gid = 0;
  #endif
  release(&ptable.lock);
}
#endif

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
#ifdef CS333_P3
int
fork(void)
{
  int i;
  uint pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    #ifdef CS333_P3
    //Embryo to unused.
    /*1.*/acquire(&ptable.lock);
    /*2.*/stateListRemove(&ptable.list[np->state],np);
    /*3.*/assertState(np,EMBRYO);
    /*4. was here before changes*/np->state = UNUSED;
    /*5.*/stateListAdd(&ptable.list[np->state],np);
    /*6.*/release(&ptable.lock);
    #else
    np->state = UNUSED;
    #endif
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;
  #ifdef CS333_P2
  np->uid = curproc->uid;
  np->gid = curproc->gid;
  #endif
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);
  #ifdef CS333_P3
  //Embryo to runnable.
  /*1. Lock acquired on line 411.*/
  /*2.*/stateListRemove(&ptable.list[np->state],np);
  /*3.*/assertState(np,EMBRYO);
  /*4. here before changes*/np->state = RUNNABLE;
  /*5.*/stateListAdd(&ptable.list[np->state],np);
  /*6.lock released on line 423.*/
  #else
  np->state = RUNNABLE;
  #endif
  release(&ptable.lock);

  return pid;
}
#else
int
fork(void)
{
  int i;
  uint pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;
  #ifdef CS333_P2
  np->uid = curproc->uid;
  np->gid = curproc->gid;
  #endif
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);
  np->state = RUNNABLE;
  release(&ptable.lock);

  return pid;
}
#endif
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifdef CS333_P3
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  #ifdef CS333_P3
  /*1. lock acquired on line 501*/
  /*2.*/stateListRemove(&ptable.list[curproc->state],curproc);
  /*3.*/assertState(curproc,RUNNING);
  /*4. here before changes*/curproc->state = ZOMBIE;
  /*5.*/stateListAdd(&ptable.list[curproc->state],curproc);
  /*6.*/release(&ptable.lock);
  #else
  curproc->state = ZOMBIE;
  #endif
  //running to zombie.
  sched();
  panic("zombie exit");
}
#else
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}
#endif
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifdef CS333_P3
int
wait(void)
{
  struct proc *p;
  int havekids;
  uint pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        #ifdef CS333_P3
	///zombie to unused
        /*1.lock acquired on line 585.*/
	/*2.*/stateListRemove(&ptable.list[p->state],p);
	/*3.*/assertState(p,ZOMBIE);
        /*4. here before changes*/p->state = UNUSED;
	/*5.*/stateListAdd(&ptable.list[p->state],p);
	/*6.  Lock released on line 614.*/
	#else
        p->state = UNUSED;
	#endif
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
#else
int
wait(void)
{
  struct proc *p;
  int havekids;
  uint pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
#endif
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
#ifdef CS333_P3
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
#ifdef PDX_XV6
  int idle;  // for checking if processor is idle
#endif // PDX_XV6

  for(;;){
    // Enable interrupts on this processor.
    sti();

#ifdef PDX_XV6
    idle = 1;  // assume idle unless we schedule a process
#endif // PDX_XV6
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
#ifdef PDX_XV6
      idle = 0;  // not idle this timeslice
#endif // PDX_XV6
      #ifdef CS333_P2
      p->cpu_ticks_in = ticks;
      #endif
      c->proc = p;
      switchuvm(p);
      //runnable to running.
      #ifdef CS333_P3
      /*1.Lock acquired in line 680.*/
      /*2.*/stateListRemove(&ptable.list[p->state],p);
      /*3.*/assertState(p,RUNNABLE);
      /*4.here before changes*/p->state = RUNNING;
      /*5.*/stateListAdd(&ptable.list[p->state],p);
      /*6. Lock released in line 714.*/
      #else
      p->state = RUNNING;
      #endif
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
#ifdef PDX_XV6
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
#endif // PDX_XV6
  }
}
#else
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
#ifdef PDX_XV6
  int idle;  // for checking if processor is idle
#endif // PDX_XV6

  for(;;){
    // Enable interrupts on this processor.
    sti();

#ifdef PDX_XV6
    idle = 1;  // assume idle unless we schedule a process
#endif // PDX_XV6
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
#ifdef PDX_XV6
      idle = 0;  // not idle this timeslice
#endif // PDX_XV6
      #ifdef CS333_P2
      p->cpu_ticks_in = ticks;
      #endif
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
#ifdef PDX_XV6
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
#endif // PDX_XV6
  }
}
#endif
// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();
  #ifdef CS333_P2
 // p->cpu_ticks_total = ticks;
  p->cpu_ticks_total += ticks - p->cpu_ticks_in;
  #endif
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
#ifdef CS333_P3
void
yield(void)
{
  struct proc *curproc = myproc();

  acquire(&ptable.lock);  //DOC: yieldlock
  #ifdef CS333_p3
  //Running to runnable
  /*1. Lock acquired on line 814.*/
  /*2.*/stateListRemove(&ptable.list[curproc->state],
curproc);
  /*3.*/assertState(curproc,RUNNING);
  /*4. here before changes.*/curproc->state = RUNNABLE;
  /*5.*/stateListAdd(&ptable.list[curproc->state],curproc);
  /*6. lock released in line 828.*/
  #else
  curproc->state = RUNNABLE;
  #endif
  sched();
  release(&ptable.lock);
}
#else
void
yield(void)
{
  struct proc *curproc = myproc();

  acquire(&ptable.lock);  //DOC: yieldlock
  curproc->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}
#endif
// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
#ifdef CS333_P3
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if(p == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    if (lk) release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  #ifdef CS333_P3
  /*1. lock acquired on line 881.*/
  /*2.*/stateListRemove(&ptable.list[p->state],p);
  /*3.*/assertState(p,RUNNING);
  /*4. here before changes*/p->state = SLEEPING;
  /*5.*/stateListAdd(&ptable.list[p->state],p);
  /*6. lock released on line 904.*/
  #else
  p->state = SLEEPING;
  #endif

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    if (lk) acquire(lk);
  }
}
#else
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if(p == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    if (lk) release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;
  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    if (lk) acquire(lk);
  }
}
#endif
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
#ifdef CS333_P3
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan){
      #ifdef CS333_P3
      /* Sleeping to runnable.*/
      /*1. locks acquired in every instance that wakeup1 is called.*/
      /*2.*/stateListRemove(&ptable.list[p->state],p);
      /*3.*/assertState(p,SLEEPING);
      /*4. here before changes.*/p->state = RUNNABLE;
      /*5.*/stateListAdd(&ptable.list[p->state], p);
      /*6. locks released in every function that wakeup1 is called.*/
      #else
      p->state = RUNNABLE;
      #endif
     }
}
#endif
// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
#ifdef CS333_P3
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
	#ifdef CS333_P3
	//sleeping to runnable.
	/*1. lock acquired on line 1005.*/
	/*2.*/stateListRemove(&ptable.list[p->state],p);
	/*3.*/assertState(p,SLEEPING);
	/*4.here before changes*/p->state = RUNNABLE;
	/*5.*/stateListAdd(&ptable.list[p->state],p);
        /*6.lock released on line 1032.*/
	#else
        p->state = RUNNABLE;
	#endif
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
#else
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
#endif
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.

#ifdef CS333_P3
void
procdump(int key_command)
#else
void
procdump(void)
#endif
{
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  #ifdef CS333_P3
  int number_of_free_processes =0;
  int number_of_processes_for_list = 0;
  if(key_command == 1)//ctrl+P
  {
  #endif
    #ifdef CS333_P2
    cprintf("PID\tNAME\tUID\tGID\tPPID\tELAPSED\tCPU\tSTATE\t\tSIZE\tPC's\n");
    #elif CS333_P1
    cprintf("%s\t%s\t%s\t%s\t%s\t%s\t\n","PID","NAME","STATE","ELAPSED","SIZE","PC's");
    #endif

  #ifdef CS333_P3
  }
    else if(key_command == 2)//ready list
    {
      cprintf("READY LIST!\n");
    }
    else if(key_command == 3)//free list
    {
      cprintf("FREE LIST!\n");
    }
    else if( key_command == 4)//sleep list
    {
      cprintf("SLEEP LIST!\n");
    }
    else if(key_command == 5)//zombie list
    {
      cprintf("ZOMBIE LIST!\n");
    }
    else
    {
      cprintf("Unknown key command:%d",key_command);
      return;
    }
  #endif
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED){
       #ifdef CS333_P3
       ++number_of_free_processes;
       #endif
       continue;
    }
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
    state = "???";
    #ifdef CS333_P3
    if(key_command == 1)
    {
    #endif
      #ifdef CS333_P2
      P2_display(p,state);
      #elif CS333_P1
      P1_display(p,state);
      #else
      cprintf("%d\t%s\t%s\t", p->pid, p->name, state);
      #endif

      if(p->state == SLEEPING){
        getcallerpcs((uint*)p->context->ebp+2, pc);
        for(i=0; i<10 && pc[i] != 0; i++)
          cprintf(" %p", pc[i]);
      }
      cprintf("\n");
    #ifdef CS333_P3
    }
    else if(key_command == 2 && p->state == RUNNABLE)//ready list
    {
      if(number_of_processes_for_list ==0)
      {
        cprintf("%d",p->pid);
      }
      else
      {
        cprintf("->%d",p->pid);
      }
      number_of_processes_for_list++;
    }
    /*else if(key_command == 3 && p->state == UNUSED)//free list
    {
      number_of_free_processes++;
    }*/
    else if( key_command == 4 && p->state == SLEEPING)//sleep list
    {
      if(number_of_processes_for_list ==0)
      {
        cprintf("%d",p->pid);
      }
      else
      {
        cprintf("->%d",p->pid);
      }
      number_of_processes_for_list++;
    }
    else if(key_command == 5 && p->state == ZOMBIE)//zombie list
    {
      if(number_of_processes_for_list ==0)
      {
        cprintf("(process:%d,parent:%d)",p->pid,p->parent->pid);
      }
      else
      {
        cprintf("->%d",p->pid);
      }
      number_of_processes_for_list++;
    }
    else
    {
      //cprintf("Unknown key command: %d",key_command);
      //return;
    }
    #endif
  }
  #ifdef CS333_P3
  if(key_command !=1)
  {
    if(key_command == 3)
    {
      cprintf("Free list size: %d proceses.\n", number_of_free_processes);
    }
    if(key_command ==2 && number_of_processes_for_list ==0)
    {
      cprintf("There were no processes in the ready list.\n");
    }
    else if(key_command==3 && number_of_free_processes ==0)
    {
      cprintf("There were no processes in the free list.\n");
    }
    else if(key_command==4 && number_of_processes_for_list ==0)
    {
      cprintf("There were not processes in the sleeping list.\n");
    }
    else if(key_command==5 && number_of_processes_for_list ==0)
    {
      cprintf("There were not processes in the zombie list.\n");
    }
    else
    {
      cprintf("\n");
    }
  }
  #endif
}

#ifdef CS333_P1
int
P1_display(struct proc *p, char* state)
{
  cprintf("%d\t%s\t%s\t", p->pid, p->name, state);
  procdump_P1_Helper(p);
  return 0;
}


void
procdump_P1_Helper(struct proc *p)
{
  int seconds =(ticks-p->start_ticks)/1000;
  int miliseconds =(ticks-p->start_ticks)%1000;
  cprintf("%d%s%d\t%d\t",seconds,".",miliseconds,p->sz);
}
#endif

#ifdef CS333_P2

int
P2_display(struct proc *p, char* state)
{
  uint ppid_get;
  if(strncmp(p->name,"init",16)==0||p->parent==NULL)
    {
      ppid_get = p->pid;
    }
  else
    {
      ppid_get = p->parent->pid;
    }
  cprintf("%d\t%s\t%d\t%d\t%d\t",p->pid,p->name,p->uid,p->gid,ppid_get);
  time_display(ticks-p->start_ticks);//elapsed
  time_display(p->cpu_ticks_total);//CPU
  cprintf("%s\t\t%d\t",state,p->sz);
  return 0;
}
void
time_display(uint time_input)
{
  int seconds =(time_input)/1000;
  int miliseconds =(time_input)%1000;
  if(miliseconds/100==0 && miliseconds/10 >=1)//10-99 to 010-099
  {
    cprintf("%d.0%d\t",seconds,miliseconds);
  }
  else if(miliseconds/10==0)//1-9 to 001-009
  {
    cprintf("%d.00%d\t",seconds,miliseconds);
  }
  else
  {
    cprintf("%d.%d\t",seconds,miliseconds);
  }
}
#endif
#ifdef CS333_P2
int
populateprocs(uint max,struct uproc* table)
{
  struct proc* p;
  int processes_acquired = 0;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if(processes_acquired == max)
    {
      break;
    }
    if(p->state !=UNUSED &&p->state !=EMBRYO)
    {
    	table[processes_acquired].pid = p->pid;
    	table[processes_acquired].uid = p->uid;
    	table[processes_acquired].gid = p->gid;
        if(p->parent->pid !=NULL && strncmp(p->name,"init",16)!=0)
	{
    	  table[processes_acquired].ppid = p->parent->pid;
	}
	else
	{
	  table[processes_acquired].ppid = p->pid;
	}
    	table[processes_acquired].elapsed_ticks = ticks-p->start_ticks;
//    	table[processes_acquired].CPU_total_ticks = p->cpu_ticks_total-p->cpu_ticks_in;
     	table[processes_acquired].CPU_total_ticks = p->cpu_ticks_total;
//	strncpy(table[processes_acquired].state,(char*)p->state,16);
	if(p->state == RUNNING)
	{
	  strncpy(table[processes_acquired].state,"RUNNING ",16);
	}
	else if(p->state == SLEEPING)
	{
	  strncpy(table[processes_acquired].state,"SLEEPING",16);
	}
	else if(p->state == RUNNABLE)
	{
	  strncpy(table[processes_acquired].state,"RUNNABLE",16);
	}
	else if(p->state == ZOMBIE)
	{
	  strncpy(table[processes_acquired].state,"ZOMBIE ",16);
	}
	else
	{
	  strncpy(table[processes_acquired].state,"UNKNOWN ",16);
	}
    	table[processes_acquired].size = p->sz;
	strncpy(table[processes_acquired].name,p->name,16);
        ++processes_acquired;
//	cprintf("Process added\n");
    }
  }
   release(&ptable.lock);
  return processes_acquired;;
}
#endif

// list management function prototypes

// list management helper functions
#ifdef CS333_P3
static void
stateListAdd(struct ptrs* list, struct proc* p)
{
  if((*list).head == NULL){
    (*list).head = p;
    (*list).tail = p;
    p->next = NULL;
  } else{
    ((*list).tail)->next = p;
    (*list).tail = ((*list).tail)->next;
    ((*list).tail)->next = NULL;
  }
}

static int
stateListRemove(struct ptrs* list, struct proc* p)
{
  if((*list).head == NULL || (*list).tail == NULL || p == NULL){
    return -1;
  }

  struct proc* current = (*list).head;
  struct proc* previous = 0;

  if(current == p){
    (*list).head = ((*list).head)->next;
    // prevent tail remaining assigned when we've removed the only item
    // on the list
    if((*list).tail == p){
      (*list).tail = NULL;
    }
    return 0;
  }

  while(current){
    if(current == p){
      break;
    }

    previous = current;
    current = current->next;
  }

  // Process not found. return error
  if(current == NULL){
    return -1;
  }

  // Process found.
  if(current == (*list).tail){
    (*list).tail = previous;
    ((*list).tail)->next = NULL;
  } else{
    previous->next = current->next;
  }

  // Make sure p->next doesn't point into the list.
  p->next = NULL;

  return 0;
}

static void
initProcessLists()
{
  int i;

  for (i = UNUSED; i <= ZOMBIE; i++) {
    ptable.list[i].head = NULL;
    ptable.list[i].tail = NULL;
  }
#ifdef CS333_P4
  for (i = 0; i <= MAXPRIO; i++) {
    ptable.ready[i].head = NULL;
    ptable.ready[i].tail = NULL;
  }
#endif
}

static void
initFreeList(void)
{
  struct proc* p;

  for(p = ptable.proc; p < ptable.proc + NPROC; ++p){
    p->state = UNUSED;
    stateListAdd(&ptable.list[UNUSED], p);
  }
}

static void assertState(struct proc* curproc, enum procstate curstate)
{
  if(curproc->state != curstate)
  {
    panic("ERROR: The process is does not match the state.");
  }
}
#endif
