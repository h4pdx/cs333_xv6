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

#ifdef CS333_P3P4
struct StateLists {
    struct proc* ready;
    struct proc* free;
    struct proc* sleep;
    struct proc* zombie;
    struct proc* running;
    struct proc* embryo;
};

// StateLists management helper-function stubs: Lines 854 +
static void assertState(struct proc* p, enum procstate state);
static int addToStateListHead(struct proc** sList, struct proc* p);
static int addToStateListEnd(struct proc** sList, struct proc* p);
static int removeFromStateList(struct proc** sList, struct proc* p);
static struct proc* removeHead(struct proc** sList);
#endif

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
#ifdef CS333_P3P4
  struct StateLists pLists;
#endif
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);


static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
};
void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.

#ifndef CS333_P3P4
// ORIGINAL ALLOCPROC
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  return 0;

found:
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
#else
// PROJECT 3 + 4 ALLOCPROC
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;
  //char * state;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  return 0;

found:
  
  //cprintf("assertState line 137.\n");
  //assertState(p, UNUSED);
  /*
  if (removeFromStateList(&ptable.pLists.free, p) == -1) {
      //panic("failed to remove from UNUSED list (allocproc).\n");
      cprintf("Failed to remove from UNUSED list (allocproc).\n");
  }
  */
  //cprintf("Current state: %s.\n", states[p->state]);
  assertState(p, UNUSED);
  if (removeFromStateList(&ptable.pLists.free, p) == -1) {
      cprintf("Alloc proc failed to remove proc from UNUSED (to EMBRYO).\n");
  }
  p->state = EMBRYO;
  if (addToStateListHead(&ptable.pLists.embryo, p) == -1) {
      cprintf("Alloc proc failed to add proc to EMBRYO list (from UNUSED).\n");
  }

  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    //cprintf("Allocproc line 151.\n");
    assertState(p, EMBRYO);
    removeFromStateList(&ptable.pLists.embryo, p);

    p->state = UNUSED;

    
    if (addToStateListHead(&ptable.pLists.free, p) == -1) {
        panic ("Failed to add proc to UNUSED list (allocproc()).\n");
    }
    
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

//PAGEBREAK: 32
// Set up first user process.
#ifndef CS333_P3P4
// ORIGINAL USERINIT
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
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

#ifdef CS333_P2
  p->uid = UID;
  p->gid = GID;
  p->parent = p; // parent of proc one is itself
#endif

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");


  p->state = RUNNABLE;

}
#else
// PROJECT 3 + 4 USERINIT
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
      //p->state = UNUSED;
      //cprintf("assertState line 267.\n");
      assertState(p, UNUSED);
      if (addToStateListHead(&ptable.pLists.free, p) == -1) {
          panic("Failed to add proc to UNUSED list.\n");
      }
  }

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

#ifdef CS333_P2
  p->uid = UID;
  p->gid = GID;
  p->parent = p; // parent of proc one is itself
#endif

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  //cprintf("assertState line 316.\n");
  
  assertState(p, EMBRYO);
  if (removeFromStateList(&ptable.pLists.embryo, p) < 0) {
      cprintf("Failed to remove EMBRYO proc from list (userinit).\n");
  }
  

  p->state = RUNNABLE;
  

  ptable.pLists.ready = p;  // add to head of ready list
  p->next = 0;
  ptable.pLists.sleep = 0;  // initialize rest of the lists to NULL
  ptable.pLists.zombie = 0;
  ptable.pLists.running = 0;
  //ptable.pLists.embryo = 0;
}
#endif

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
#ifndef CS333_P3P4
// ORIGINAL FORK PROCESS
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));

#ifdef CS333_P2
  np->uid = proc->uid;
  np->gid = proc->gid;
#endif
 
  pid = np->pid;

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
  np->state = RUNNABLE;
  release(&ptable.lock);
  
  return pid;
}
#else
// PROJECT 3 + 4 FORK
int
fork(void)
{
  int i, pid;
  struct proc *np;

  //cprintf("In fork()\n.");
  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;

    //cprintf("assertState line 430.\n");
    assertState(np, EMBRYO);
    if (removeFromStateList(&ptable.pLists.embryo, np) < 0) {
        panic("Failed to remove proc from EMBRYO list (fork).\n");
    }
    np->state = UNUSED;
    
    //cprintf("assertState line 436.\n");
    //assertState(np, UNUSED);
    if (addToStateListHead(&ptable.pLists.free, np) < 0) {
        panic("Failed to add proc to UNUSED list (fork).\n");
    }

    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));

#ifdef CS333_P2
  np->uid = proc->uid;
  np->gid = proc->gid;
#endif
 
  pid = np->pid;

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
  //cprintf("assertState line 465.\n");
  assertState(np, EMBRYO);
  if (removeFromStateList(&ptable.pLists.embryo, np) < 0) {
      cprintf("Failed to remove EMBRYO proc from list (fork).\n");
  }

  np->state = RUNNABLE;
  
  //cprintf("assertState line 446.\n");
  //assertState(np, RUNNABLE);
  if (addToStateListHead(&ptable.pLists.ready, np) < 0) {
      cprintf("Failed to add RUNNABLE proc to list (fork).\n");

  }
  
  release(&ptable.lock);
  
  return pid;
}
#endif

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifndef CS333_P3P4
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}
#else
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  //cprintf("assertState - line 563.\n");
  assertState(proc, RUNNING);
  if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
      cprintf("Failed to remove RUNNING proc from list (exit).\n");
  }
  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  //ssertState(proc, ZOMBIE);
  
  if (addToStateListHead(&ptable.pLists.zombie, proc) < 0) {
      cprintf("Failed to add ZOMBIE proc to list (exit).\n");
  }
  
  sched();
  panic("zombie exit");

}
#endif

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifndef CS333_P3P4
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
#else
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
      // Scan through table looking for zombie children.
      havekids = 0;
      /*
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->parent != proc)
        continue;
        */
      p = ptable.pLists.zombie;

      while (p) {
          if (p->parent == proc) {
              havekids = 1;
              //if(p->state == ZOMBIE)
              // Found one.
              pid = p->pid;
              kfree(p->kstack);
              p->kstack = 0;
              freevm(p->pgdir);
              assertState(p, ZOMBIE);
              /*
              if (removeFromStateList(&ptable.pLists.zombie, p) < 0) {
                  panic("Failed to remove from ZOMBIE list (wait).\n");
              }
              */
              p = removeHead(&ptable.pLists.zombie);
              p->state = UNUSED;
              if (addToStateListHead(&ptable.pLists.free, p) < 0) {
                  panic("Failed to add to UNUSED list (wait).\n");
              }
              p->pid = 0;
              p->parent = 0;
              p->name[0] = 0;
              p->killed = 0;
              release(&ptable.lock);
              return pid;
          }
          p = p->next;
      }

      p = ptable.pLists.ready;
      while (!havekids && p) {
          if (p->parent == proc) {
              havekids = 1;
          }
          p = p->next;
      }

      p = ptable.pLists.running;
      while (!havekids && p) {
          if (p->parent == proc) {
              havekids = 1;
          }
          p = p->next;
      }

      p = ptable.pLists.sleep;
      while (!havekids && p) {
          if (p->parent == proc) {
              havekids = 1;
          }
          p = p->next;
      }
      // No point waiting if we don't have any children.
      if(!havekids || proc->killed) {
          release(&ptable.lock);
      return -1;
      }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
  //return 0;  // placeholder
}
#endif

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
#ifndef CS333_P3P4
// original xv6 scheduler. Use if CS333_P3P4 NOT defined.
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
      proc = p;
      switchuvm(p);
      p->state = RUNNING;

#ifdef CS333_P2
      p->cpu_ticks_in = ticks; // ticks when scheduled
#endif

      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}

#else

void
scheduler(void)
{

  struct proc *p;
  int idle;  // for checking if processor is idle
  //char * state;

  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);

    if (ptable.pLists.ready) {
        p = ptable.pLists.ready;
        if (!p) {
            cprintf("p is NULL.\n");
        }

        //cprintf(" >> scheduler()\n");
        //state = states[p->state];
        //cprintf("p->state = %s.\n", state);
        assertState(p, RUNNABLE);
        /*
        p = removeHead(&ptable.pLists.ready);
        */
        if (removeFromStateList(&ptable.pLists.ready, p) < 0) {
            cprintf("Failed to remove RUNNABLE proc from list (scheduler).");
        }
        idle = 0;
        proc = p;
        switchuvm(p);
        p->state = RUNNING;
        addToStateListEnd(&ptable.pLists.running, p);

#ifdef CS333_P2
        p->cpu_ticks_in = ticks; // ticks when scheduled
#endif

        swtch(&cpu->scheduler, proc->context);
        switchkvm();

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        proc = 0;
    }
    release(&ptable.lock);



    /*
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
      proc = p;
      switchuvm(p);
      assertState(p, RUNNABLE);
      //removeFromStateList(&ptable.pLists.ready, p);

      p->state = RUNNING;

      //addToStateListEnd(&ptable.pLists.running, p);
    }
    */
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }

}
#endif

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
#ifndef CS333_P3P4
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;

#ifdef CS333_P2
  proc->cpu_ticks_total += (ticks - proc->cpu_ticks_in);
#endif

  swtch(&proc->context, cpu->scheduler);

  cpu->intena = intena;
}
#else
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;

#ifdef CS333_P2
  proc->cpu_ticks_total += (ticks - proc->cpu_ticks_in);
#endif

  swtch(&proc->context, cpu->scheduler);

  cpu->intena = intena;
}
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
#ifdef CS333_P3P4
  assertState(proc, RUNNING);
  if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
      cprintf("Failed to remove RUNNING proc to list (yeild).");
  }
#endif

  proc->state = RUNNABLE;

#ifdef CS333_P3P4
  if (addToStateListEnd(&ptable.pLists.ready, proc) < 0) {
      cprintf("Failed to add RUNNABLE proc to list (yeild).");
  }
#endif
  sched();
  release(&ptable.lock);
}

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
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
    acquire(&ptable.lock);
    if (lk) release(lk);
  }

  // Go to sleep.
  proc->chan = chan;

#ifdef CS333_P3P4
  assertState(proc, RUNNING);
  if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
      cprintf("Could not remove RUNNING proc from list (sleep()).\n");
  }
#endif
  proc->state = SLEEPING;

#ifdef CS333_P3P4
  if (addToStateListEnd(&ptable.pLists.sleep, proc) < 0) {
      cprintf("Could not add SLEEPING proc to list (sleep()).\n");
  }
#endif

  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
    release(&ptable.lock);
    if (lk) acquire(lk);
  }
}

//PAGEBREAK!
#ifndef CS333_P3P4
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
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

  /*
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if(p->state == SLEEPING && p->chan == chan) {
      p->state = RUNNABLE;
    }
  }
  */
  /*
  p = ptable.pLists.sleep;
  while (p) {
      if (p->chan == chan) {
          cprintf("assertState - line 942.\n");
          assertState(p, SLEEPING);
          removeFromStateList(&ptable.pLists.sleep, p);

          p->state = RUNNABLE;

          //assertState(p, RUNNABLE);
          addToStateListEnd(&ptable.pLists.ready, p);
      }
      p = p->next;
  }
  */
  if (ptable.pLists.sleep) {
      struct proc * current  = ptable.pLists.sleep;
      p = 0;
      while (current) {
          p = current;
          current = current->next;
          //cprintf("wakeup1()\n");
          assertState(p, SLEEPING);
          if (p->chan == chan) {
              /*
              p = removeHead(&ptable.pLists.sleep);
              */
              if (removeFromStateList(&ptable.pLists.sleep, p) < 0) {
                  cprintf("Failed to remove SLEEPING proc to list (wakeup1).\n");
              }
              p->state = RUNNABLE;
              if (addToStateListEnd(&ptable.pLists.ready, p) < 0) {
                  cprintf("Failed to add RUNNABLE proc to list (wakeup1).\n");
              }
          }
         // p = p->next;
      }
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
#ifndef CS333_P3P4
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
      if(p->state == SLEEPING) {
        assertState(p, SLEEPING);
        if (removeFromStateList(&ptable.pLists.sleep, p) < 0) {
            cprintf("Could not remove SLEEPING proc from list (kill()).\n");
        }
        p->state = RUNNABLE;
        if (addToStateListEnd(&ptable.pLists.ready, p) < 0) {
            cprintf("Could not add RUNNABLE proc to list (kill()).\n");
        }

      }
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
#endif
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.

#ifdef CS333_P1
void
elapsed_time(uint p_ticks)
{
    uint elapsed, whole_sec, milisec_ten, milisec_hund, milisec_thou;
    //elapsed = ticks - p->start_ticks; // find original elapsed time
    elapsed = p_ticks;
    whole_sec = (elapsed / 1000); // the the left of the decimal point
    // % to shave off leading digit of elapsed for decimal place calcs
    milisec_ten = ((elapsed %= 1000) / 100); // divide and round up to nearest int
    milisec_hund = ((elapsed %= 100) / 10); // shave off previously counted int, repeat
    milisec_thou = (elapsed %= 10); // determine thousandth place
    cprintf("\t%d.%d%d%d", whole_sec, milisec_ten, milisec_hund, milisec_thou);
}
#endif

void
procdump(void)
{
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  // formatting if project 1 is enabled in makefile
  // and only if P2 is NOT enabled
#ifndef CS333_P2
#ifdef CS333_P1
  cprintf("\n%s\t%s\t%s\t%s\t%s\n",
          "PID", "State", "Name", "Elapsed", "PCs");
#endif
#endif

  // formatting if project 2 is enabled in makefile
#ifdef CS333_P2
  cprintf("\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
          "PID", "Name", "UID", "GID", "PPID", "Elapsed", "CPU", "State", "Size", "PCs");
#endif

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    // original display without P1 or P2
    // only display if project 2 is NOT enabled
#ifndef CS333_P2
    cprintf("%d\t%s\t%s", p->pid, state, p->name);
#endif

    // formatting if project 1 is enabled in makefile
    // only display if project 2 is NOT enabled
#ifndef CS333_P2
#ifdef CS333_P1
    elapsed_time(ticks - p->start_ticks);
#endif
#endif

    // formatting if project 2 is enabled in makefile
#ifdef CS333_P2
    cprintf("%d\t%s\t%d\t%d\t%d",
            p->pid, p->name, p->uid, p->gid, p->parent->pid);
    elapsed_time(ticks - p->start_ticks);
    elapsed_time(p->cpu_ticks_total);
    cprintf("\t%s\t%d", state, p->sz);
#endif

    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf("\t%p", pc[i]);
    }
    cprintf("\n");
  }
}

#ifdef CS333_P2
// loop process table and copy active processes, return number of copied procs
// populate uproc array passed in from ps.c
int
getprocs(uint max, struct uproc *table)
{
    int i = 0;
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC] && i < max; p++) {
        // only copy active processes
        if (p->state == RUNNABLE || p->state == RUNNING || p->state == SLEEPING) {
            table[i].pid = p->pid;
            table[i].uid = p->uid;
            table[i].gid = p->gid;
            if (p->pid == 1) {
                table[i].ppid = 1;
            } else {
                table[i].ppid = p->parent->pid;
            }
            table[i].elapsed_ticks = (ticks - p->start_ticks);
            table[i].CPU_total_ticks = p->cpu_ticks_total;
            safestrcpy(table[i].state, states[p->state], STRMAX);
            table[i].size = p->sz;
            safestrcpy(table[i].name, p->name, STRMAX);
            ++i;
        }
    }
    release(&ptable.lock);
    return i; // return number of procs copied
}
#endif

#ifdef CS333_P3P4
static void
assertState(struct proc* p, enum procstate state) {
    // check for null args
    // compare p->state with states[state]
    // panic if not matching, print out [state]
    //cprintf("Assert State function.\n");
    if (p == 0) {
        panic("assertState: invalid proc argument.\n");
    }
    if (p->state != state) {
        //cprintf("Process in state: %s.\n", p->state);
        panic("assertState: process in wrong state.\n");
    }
}

static int
addToStateListHead(struct proc** sList, struct proc* p) {
    if (!(*sList)) { // if no list exists, make first entry
        (*sList) = p; // arg proc is now the first item in list
        p->next = 0; // next is null
        //cprintf("Initialized first proc to list.\n");
        return 0; // return success
    }
    // otherwise hold to next element and become 1st element
    p->next = (*sList); // arg proc has next element
    (*sList) = p; // reassign head of list to arg proc
    //cprintf("Added new proc to head of list.\n");
    if (p != (*sList)) {
        return -1; // if they don't match, return failure
    }
    return 0; // return success
}

static int
addToStateListEnd(struct proc** sList, struct proc* p) {
    // check for null args
    // create temp proc pointer
    // loop to end
    // add to end
    // set next to null
    // return
    if (!p) {
        panic("Invalid process.");
    }
    if (!(*sList)) {
        (*sList) = p;
        p->next = 0;
        return 0;
    }
    /*
    if (!(*sList)->next) {
        (*sList)->next = p;
        p->next = 0;
        return 0;
    }
    */
    struct proc * current = (*sList);
    while (current->next) {
        current = current->next;
    }
    current->next = p;
    p->next = 0;
    return 0;
}

static int
removeFromStateList(struct proc** sList, struct proc* p) {
    if (!(*sList) || !p) {
        panic("Invalid process structures.");
    }
    // if p is the first element in list

    if (p == (*sList)) {
        //cprintf("removeFromStateList: (p == (*sList))\n");
        // if it is the only item in list
        if (!(*sList)->next) {
            (*sList) = 0;
            //(*sList)->next = 0;
            p->next = 0;
            //cprintf("Only item removed from list.\n");
            return 0;
        }
        // if p is the first item in list
        else {
            struct proc * temp = (*sList)->next;
            p->next = 0;
            (*sList) = temp;
            //cprintf("First process removed from list.\n");
            return 0;
        }
    }
    // from middle or end of list
    else {
        //cprintf("removeFromStateList: (else case).\n");
        struct proc * current = (*sList)->next;
        struct proc * prev = (*sList);
        while (current) {
            if (current == p) {
                prev->next = current->next;
                p->next = 0;
                //cprintf("Process removed from List.\n");
                return 0;
            }
            prev = current;
            current = current->next;
        }
    }
    //cprintf("removeFromStateList has not found anything to remove.\n");
    return -1; // nothing found
}


struct proc*
removeHead(struct proc** sList) {
    if (!(*sList)) {
        return 0; // return null, check value in calling routine
    }
    struct proc* p = (*sList); // assign pointer to head of sList
    struct proc* temp = (*sList)->next; // hold onto next elemnt in list
    p->next = 0; // p is no longer head of sList
    (*sList) = temp; // sList now starts at  2nd element, or is NULL if one-item list
    return p; // return 
}


#endif
