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
    struct proc* ready[MAX+1];     // RUNNABLE process list
    struct proc* free;      // UNUSED
    struct proc* sleep;     // SLEEPING
    struct proc* zombie;    // ZOMBIE
    struct proc* running;   // RUNNING
    struct proc* embryo;    // EMBRYO
};

// StateLists management helper-function stubs: Lines 1190 - 1291
static void assertState(struct proc* p, enum procstate state);  // panic if state is what it is supposed to be
static int addToStateListHead(struct proc** sList, struct proc* p); // initialize or add to list, at front
static int addToStateListEnd(struct proc** sList, struct proc* p); // initialize or add to list, at back
static int removeFromStateList(struct proc** sList, struct proc* p); // search & remove based on pointer comparison
static struct proc* removeHead(struct proc** sList);    // remove first object in given list, return pointer
static void promoteAll(void);
#endif

struct {
    struct spinlock lock;
    struct proc proc[NPROC];
#ifdef CS333_P3P4
    struct StateLists pLists; // Project 3
    uint promoteAtTime; // Project 4
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
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if(p->state == UNUSED) {
            goto found;
        }
    }
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

    acquire(&ptable.lock);
    p = ptable.pLists.free;
    if (p) {
        goto found;
    }
    release(&ptable.lock);
    return 0;

found:

    assertState(p, UNUSED);
    if (removeFromStateList(&ptable.pLists.free, p) == -1) {
        cprintf("Failed to remove proc from UNUSED list (allocproc).\n");
    }
    p->state = EMBRYO;
    if (addToStateListHead(&ptable.pLists.embryo, p) == -1) {
        cprintf("Failed to add proc to EMBRYO list (allocproc).\n");
    }

    p->pid = nextpid++;
    release(&ptable.lock);

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
        assertState(p, EMBRYO);
        removeFromStateList(&ptable.pLists.embryo, p);
        p->state = UNUSED;
        if (addToStateListHead(&ptable.pLists.free, p) == -1) {
            cprintf("Not enough room for process stack; Failed to add proc to UNUSED list (allocproc).\n");
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

    p->start_ticks = ticks;
    p->cpu_ticks_total = 0;
    p->cpu_ticks_in = 0;

    // Project 4
    p->budget = BUDGET;
    p->priority = 0;

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
    ptable.promoteAtTime = TIME_TO_PROMOTE;
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    // Add to the END of the UNUSED list upon init, or else processes will be backwards (ctrl-p & ps)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        assertState(p, UNUSED);
        if (addToStateListEnd(&ptable.pLists.free, p) == -1) {
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

    assertState(p, EMBRYO);
    if (removeFromStateList(&ptable.pLists.embryo, p) < 0) {
        cprintf("Failed to remove EMBRYO proc from list (userinit).\n");
    }

    p->state = RUNNABLE;

    //ptable.pLists.ready = p;  // add to head of ready list

    ptable.pLists.ready[0] = p;  // add to head of highest priority ready list
    p->next = 0;
    for (int i = 1; i <= MAX; ++i) {
        ptable.pLists.ready[i] = 0; // initialize all of the other ready lists
    }
    ptable.pLists.sleep = 0;  // initialize rest of the lists to NULL
    ptable.pLists.zombie = 0;
    ptable.pLists.running = 0;
    ptable.pLists.embryo = 0;
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

    // Allocate process.
    if((np = allocproc()) == 0)
        return -1;

    // Copy process state from p.
    if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
        kfree(np->kstack);
        np->kstack = 0;
        assertState(np, EMBRYO);
        if (removeFromStateList(&ptable.pLists.embryo, np) < 0) {
            panic("Failed to remove proc from EMBRYO list (fork).\n");
        }
        np->state = UNUSED;
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

    np->uid = proc->uid;
    np->gid = proc->gid;

    pid = np->pid;

    // lock to force the compiler to emit the np->state write last.
    acquire(&ptable.lock);
    assertState(np, EMBRYO);
    if (removeFromStateList(&ptable.pLists.embryo, np) < 0) {
        cprintf("Failed to remove EMBRYO proc from list (fork).\n");
    }

    np->state = RUNNABLE;

    // add to end of highest priority queue
    if (addToStateListEnd(&ptable.pLists.ready[np->priority], np) < 0) {
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
            if(p->state == ZOMBIE) {
                wakeup1(initproc);
            }
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
    struct proc *current;
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
    current = ptable.pLists.zombie;
    while (current) {
        p = current;
        current = current->next;
        if (p->parent == proc) {
            p->parent = initproc;
            wakeup1(initproc);
        }
    }
    p = ptable.pLists.running; // now running list
    while (p) {
        if(p->parent == proc){
            p->parent = initproc;
        }
        p = p->next;
    }
    // traverse array of ready lists
    for (int i = 0; i <= MAX; ++i) {
        p = ptable.pLists.ready[i]; // now ready
        while (p) {
            if (p->parent == proc) {
                p->parent = initproc;
            }
            p = p->next;
        }
    }
    p = ptable.pLists.sleep; // sleeping list
    while (p) {
        if (p->parent == proc) {
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.embryo; // embryo list
    while (p) {
        if (p->parent == proc) {
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.free; // free list
    while (p) {
        if (p->parent == proc) {
            p->parent = initproc;
        }
        p = p->next;
    }

    assertState(proc, RUNNING);
    if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
        cprintf("Failed to remove RUNNING proc from list (exit).\n");
    }
    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
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
        // start at zombie list
        p = ptable.pLists.zombie;
        while (!havekids && p) {
            if (p->parent == proc) {
                havekids = 1;
                pid = p->pid;
                kfree(p->kstack);
                p->kstack = 0;
                freevm(p->pgdir);
                assertState(p, ZOMBIE);
                if (removeFromStateList(&ptable.pLists.zombie, p) < 0) {
                    cprintf("Failed to remove ZOMBIE process from list (wait).\n");
                }
                p->state = UNUSED;
                if (addToStateListHead(&ptable.pLists.free, p) < 0) {
                    cprintf("Failed to add UNUSED process to list (wait).\n");
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
        // Runnable list
        for (int i = 0; i <= MAX; i++) {
            p = ptable.pLists.ready[i];
            while (!havekids && p) {
                if (p->parent == proc) {
                    havekids = 1;
                }
                p = p->next;
            }
        }
        // Running list
        p = ptable.pLists.running;
        while (!havekids && p) {
            if (p->parent == proc) {
                havekids = 1;
            }
            p = p->next;
        }
        // Sleep list
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
// Project 3 scheduler
void
scheduler(void)
{
    struct proc *p;
    int idle;  // for checking if processor is idle
    int ran; // ready list loop condition 
    for(;;) {
        // Enable interrupts on this processor.
        sti();
        idle = 1;  // assume idle unless we schedule a process
        ran = 0; // reset ran, look for another process
        // Loop over process table looking for process to run.
        acquire(&ptable.lock);

        if ((ptable.promoteAtTime) == ticks) {
            //cprintf("Promotion occurred.\n");
            promoteAll(); // RUNNING, RUNNABLE, SLEEPING
            ptable.promoteAtTime = (ticks + TIME_TO_PROMOTE); // update next time we will promote everything
        }
        for (int i = 0; (i <= MAX) && (ran == 0); ++i) {
            // take first process on first valid list
            p = ptable.pLists.ready[i];
            if (p) {
                // assign pointer, aseert correct state
                assertState(p, RUNNABLE);
                // take 1st process on ready list
                p = removeHead(&ptable.pLists.ready[p->priority]);
                if (!p) {
                    panic("Scheduler: removeHead failed.");
                }
                // hand over to the CPU
                idle = 0;
                proc = p;
                switchuvm(p);
                p->state = RUNNING;
                // add to end of running list
                if (addToStateListEnd(&ptable.pLists.running, p) < 0) {
                    cprintf("Failed to add RUNNING proc to list (scheduler).");
                }
                p->cpu_ticks_in = ticks; // ticks when scheduled
                swtch(&cpu->scheduler, proc->context);
                switchkvm();
                // Process is done running for now.
                // It should have changed its p->state before coming back.
                proc = 0;
                ran = 1; // exit loop after this
            }
        }
        release(&ptable.lock);
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

    proc->cpu_ticks_total += (ticks - proc->cpu_ticks_in);

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
    proc->budget -= (ticks - proc->cpu_ticks_in); // update budget, then check
    if ((proc->budget) <= 0) {
        if ((proc->priority) < MAX) {
            ++(proc->priority); // Demotion
        }
        proc->budget = BUDGET; // Reset budget
    }

    if (addToStateListEnd(&ptable.pLists.ready[proc->priority], proc) < 0) {
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
    proc->budget -= (ticks - proc->cpu_ticks_in); // update budegt, then check
    if ((proc->budget) <= 0) {
        // priority cant be greater than MAX bc it is literal index of ready list array
        if ((proc->priority) < MAX) {
            ++(proc->priority); // Demotion
        }
        proc->budget = BUDGET; // Reset budget
    }
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

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if(p->state == SLEEPING && p->chan == chan) {
            p->state = RUNNABLE;
        }
    }
}
#else
// P3 wakeup1
static void
wakeup1(void *chan)
{
    struct proc *p;
    if (ptable.pLists.sleep) {
        struct proc * current = ptable.pLists.sleep;
        p = 0;
        while (current) {
            p = current;
            current = current->next;
            assertState(p, SLEEPING);
            if (p->chan == chan) {
                if (removeFromStateList(&ptable.pLists.sleep, p) < 0) {
                    cprintf("Failed to remove SLEEPING proc to list (wakeup1).\n");
                }
                p->state = RUNNABLE;
                if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
                    cprintf("Failed to add RUNNABLE proc to list (wakeup1).\n");
                }
            }
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
    // traverse Sleeping list, wake processes if necessary
    p = ptable.pLists.sleep;
    while (p) {
        if (p->pid == pid) {
            p->killed = 1;
            assertState(p, SLEEPING);
            if (removeFromStateList(&ptable.pLists.sleep, p) < 0) {
                cprintf("Could not remove SLEEPING proc from list (kill).\n");
            }
            p->state = RUNNABLE;
            if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
                cprintf("Could not add RUNNABLE proc to list (kill).\n");
            }
            release(&ptable.lock);
            return 0;
        }
        p = p->next;
    }

    // traverse Runnable list
    for (int i = 0; i <= MAX; ++i) {
        p = ptable.pLists.ready[i];
        while (p) {
            if (p->pid == pid) {
                p->killed = 1;
                release(&ptable.lock);
                return 0;
            }
            p = p->next;
        }
    }

    // traverse Running list
    p = ptable.pLists.running;
    while (p) {
        if (p->pid == pid) {
            p->killed = 1;
            release(&ptable.lock);
            return 0;
        }
        p = p->next;
    }

    // traverse Unused List
    p = ptable.pLists.free;
    while (p) {
        if (p->pid == pid) {
            p->killed = 1;
            release(&ptable.lock);
            return 0;
        }
        p = p->next;
    }

    // traverse Zombie list
    p = ptable.pLists.zombie;
    while (p) {
        if (p->pid == pid) {
            p->killed = 1;
            release(&ptable.lock);
            return 0;
        }
        p = p->next;
    }

    // traverse Embryo list
    p = ptable.pLists.embryo;
    while (p) {
        if (p->pid == pid) {
            p->killed = 1;
            release(&ptable.lock);
            return 0;
        }
        p = p->next;
    }

    // return error
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

#ifndef CS333_P3P4
void
procdump(void)
{
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    // formatting if project 1 is enabled in makefile
    // and only if P2 is NOT enabled
    cprintf("\n%s\t%s\t%s\t%s\n", "PID", "State", "Name", "PCs");

    // formatting if project 2 is enabled in makefile

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED) {
            continue;
        }
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state]) {
            state = states[p->state];
        }
        else {
            state = "???";
        }
        cprintf("%d\t%s\t%s", p->pid, state, p->name);
        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++) {
                cprintf("\t%p", pc[i]);
            }
        }
        cprintf("\n");
    }
}
#else

// Project 3 & 4
void
procdump(void)
{
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    cprintf("\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
            "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size", "PCs");

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED)
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
        cprintf("%d\t%s\t%d\t%d\t%d",
                p->pid, p->name, p->uid, p->gid, p->parent->pid);
        cprintf("\t%d", p->priority);
        elapsed_time(ticks - p->start_ticks);
        elapsed_time(p->cpu_ticks_total);
        cprintf("\t%s\t%d", state, p->sz);

        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
                cprintf("\t%p", pc[i]);
        }
        cprintf("\n");
    }
}
#endif

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
#ifdef CS333_P3P4
            table[i].priority = p->priority;
#endif
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


//PROJECT 3
// assert that process is in proper state, otherwise panic
static void
assertState(struct proc* p, enum procstate state) {
    if (!p) {
        panic("assertState: invalid proc argument.\n");
    }
    if (p->state != state) {
        panic("assertState: process in wrong state.\n");
    }
}

static int
addToStateListHead(struct proc** sList, struct proc* p) {
    if (!p) {
        panic("Invalid process.");
    }
    if (!(*sList)) { // if no list exists, make first entry
        (*sList) = p; // arg proc is now the first item in list
        p->next = 0; // next is null
        return 0; // return success
    }
    // otherwise hold to next element and become 1st element
    p->next = (*sList); // arg proc has next element
    (*sList) = p; // reassign head of list to arg proc
    if (p != (*sList)) {
        return -1; // if they don't match, return failure
    }
    return 0; // return success
}

static int
addToStateListEnd(struct proc** sList, struct proc* p) {
    if (!p) {
        panic("Invalid process.");
    }
    // if list desn't exist yet, initialize
    if (!(*sList)) {
        (*sList) = p;
        p->next = 0;
        return 0;
    }
    // otherwise traverse and add at the end
    struct proc * current = (*sList);
    while (current->next) {
        current = current->next;
    }
    current->next = p;
    p->next = 0;
    return 0;
}

// search and remove process based on pointer address
static int
removeFromStateList(struct proc** sList, struct proc* p) {
    if (!p) {
        panic("Invalid process structures.");
    }
    if (!(*sList)) {
        return -1;
    }
    // if p is the first element in list
    if (p == (*sList)) {
        // if it is the only item in list
        if (!(*sList)->next) {
            (*sList) = 0;
            p->next = 0;
            return 0;
        }
        // if p is the first item in list
        else {
            struct proc * temp = (*sList)->next;
            p->next = 0;
            (*sList) = temp;
            return 0;
        }
    }
    // from middle or end of list
    else {
        struct proc * current = (*sList)->next;
        struct proc * prev = (*sList);
        while (current) {
            if (current == p) {
                prev->next = current->next;
                p->next = 0;
                return 0;
            }
            prev = current;
            current = current->next;
        }
    }
    return -1; // nothing found
}

// remove first element of list, return its pointer
static struct proc*
removeHead(struct proc** sList) {
    if (!(*sList)) {
        return 0; // return null, check value in calling routine
    }
    struct proc* p = (*sList); // assign pointer to head of sList
    struct proc* temp = (*sList)->next; // hold onto next element in list
    p->next = 0; // p is no longer head of sList
    (*sList) = temp; // sList now starts at  2nd element, or is NULL if one-item list
    return p; // return 
}

// print PIDs of all procs in Ready list
void
printReadyList(void) {
    //int i = 0;
    cprintf("\nReady List Processes:\n");
    //while (i <= MAX) {
    for (int i = 0; i <= MAX; ++i) {
        if (ptable.pLists.ready[i]) {
            cprintf("\n%d: ", i);
            struct proc* current = ptable.pLists.ready[i];
            while (current) {
                if (current->next) {
                    cprintf("(%d, %d)-> ", current->pid, current->budget);
                } else {
                    cprintf("(%d, %d)", current->pid, current->budget);
                }
                current = current->next;
            }
            cprintf("\n");
        }
        else {
            cprintf("\n%d: Empty.\n", i);
        }
        //++i;
    }
}

// print number of procs in Free list
void
printFreeList(void) {
    if (ptable.pLists.free) {
        int size = 0;
        struct proc * current = ptable.pLists.free;
        while (current) {
            ++size; // cycle list and keep count
            current = current->next;
        }
        /*
        for (struct proc* current = ptable.pLists.free; current; current = current->next) {
            ++size;
        }
        */
        cprintf("\nFree List Size: %d processes\n", size);
    }
    else {
        cprintf("\nNo processes on Free List.\n");
    }
}

// print PIDs of all procs in Sleep list
void
printSleepList(void) {
    //acquire(&ptable.lock);
    if (ptable.pLists.sleep) {
        struct proc* current = ptable.pLists.sleep;
        cprintf("\nSleep List Processes:\n");
        while (current) {
            if (current->next) {
                cprintf("%d -> ", current->pid);
            } else {
                cprintf("%d", current->pid);
            }
            current = current->next;
        }
        cprintf("\n");
    }
    else {
        cprintf("\nNo processes on Sleep List.\n");
    }
    //release(&ptable.lock);
}

// print PIDs & PPIDs of all procs in Zombie list
void
printZombieList(void) {
    if (ptable.pLists.zombie) {
        struct proc* current = ptable.pLists.zombie;
        cprintf("\nZombie List Processes:\n");
        while (current) {
            if (current->next) {
                cprintf("(%d, %d) -> ", current->pid, current->parent->pid);
            } else {
                cprintf("(%d, %d)", current->pid, current->parent->pid);
            }
            current = current->next;
        }
        cprintf("\n");
    }
    else {
        cprintf("\nNo processes on Zombie List.\n");
    }
}

//
// ------------------------------------------------------------------------
// PPROJECT 4

// loop thru ready list array
// loop thru list at each index
// start from 2nd highest queue (1st queue can't promote)
// remove process from ready[p->priority]->
// -> decrement priority value (lower number == higher priority) ->
// -> add to new ready list [p->priority]
// upwards to lowest priority queue

// Promote all ACTIVE(RUNNING, RUNNABLE, SLEEPING) processes one priority level
// this is only called in scheduler(), which holds &ptable.lock
static void
promoteAll(void) {
    struct proc* p; // main ptr
    struct proc* current; // 2nd ptr needed for traversal + list management
    for (int i = 1; i <= MAX; ++i) {
        // traverse ready list array
        if (ptable.pLists.ready[i]) {
            current = ptable.pLists.ready[i]; // initialize
            p = 0;
            while (current) {
                p = current; // p is the current process to adjust
                current = current->next; // current traverses one ahead
                assertState(p, RUNNABLE); // assert state, we need to swap ready lists
                if (removeFromStateList(&ptable.pLists.ready[p->priority], p) < 0) {
                    cprintf("promoteAll: Could not remove from ready list.\n");
                } // take off lower priority (whatever one it is)
                if (p->priority > 0) {
                    --(p->priority); // adjust upward (toward zero)
                } // add to higher priority list
                if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
                    cprintf("promoteAll: Could not add to ready list.\n");
                }
            }
        }
    }
    // promote all SLEEPING processes
    if (ptable.pLists.sleep) {
        p = ptable.pLists.sleep;
        while (p) {
            if (p->priority > 0) {
                --(p->priority); // promote process
            }
            p = p->next;
        }
    }
    // promote all RUNNING processes
    if (ptable.pLists.running) {
        p = ptable.pLists.running;
        while (p) {
            if (p->priority > 0) {
                --(p->priority); // promote process
            }
            p = p->next;
        }
    }
    // nothing to return, just promote anything if they are there
}
// set priority system call
// bounds enforced in sysproc.c (kernel-side)
// active processes: RUNNABLE, RUNNING, SLEEPING
int
setpriority(int pid, int priority) {
    struct proc* p;
    acquire(&ptable.lock); // maintain atomicity
    for (int i = 0; i <= MAX; ++i) {
        p = ptable.pLists.ready[i]; // traverse ready list array
        while (p) {
            // match PIDs and only if the new priority value changes anything
            if (p->pid == pid) {
                if (removeFromStateList(&ptable.pLists.ready[p->priority], p) < 0) {
                    cprintf("setpriority: remove from ready list[%d] failed.\n", p->priority);
                }// remove from old ready list
                p->priority = priority; // set priority
                if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
                    cprintf("setpriority: add to ready list[%d] failed.\n", p->priority);
                } //  add to new ready list
                p->budget = BUDGET; // reset budget
                //cprintf("setPriority: ready list priority set.\n");
                release(&ptable.lock); // release lock
                return 0; // return success
            }
            p = p->next;
        }
    }
    p = ptable.pLists.running; // repeat process if PID not found in ready lists
    while (p) {
        if (p->pid == pid) {
            p->priority = priority;
            p->budget = BUDGET;
            //cprintf("setPriority: running list priority set.\n");
            release(&ptable.lock);
            return 0; // return success
        }
        p = p->next;
    }
    p = ptable.pLists.sleep; // continue search in sleep list
    while (p) {
        if (p->pid == pid) {
            p->priority = priority;
            p->budget = BUDGET;
            //cprintf("setPriority: sleep list priority set.\n");
            release(&ptable.lock);
            return 0; //  return success
        }
        p = p->next;
    }
    //cprintf("setPriority: No priority set.\n");
    release(&ptable.lock);
    return -1; // return error if no PID match is found
}
#endif
