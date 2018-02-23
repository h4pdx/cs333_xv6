#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#ifdef CS333_P2
#include "uproc.h"
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
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
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
    if(proc->killed){
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

//Turn of the computer
int
sys_halt(void){
  cprintf("Shutting down ...\n");
  outw( 0x604, 0x0 | 0x2000);
  return 0;
}

#ifdef CS333_P1
int
sys_date(void) {
    struct rtcdate *d;
    if (argptr(0, (void*)&d, sizeof(struct rtcdate)) < 0) {
        return -1;
    } else {
        cmostime(d);
        return 0;
    }
}
#endif

#ifdef CS333_P2

// return process UID
int
sys_getuid(void) {
    return proc->uid;
}

// return process GID
int
sys_getgid(void) {
    return proc->gid;
}

// return process parent's PID
int
sys_getppid(void) {
    return proc->parent->pid;
}

// pull argument from stack, check range, set process UID
int
sys_setuid(void) {
    int n;
    if (argint(0, &n) < 0) {
        return -1;
    }
    if (n < 0 || n > 32767) {
        return -1;
    }
    proc->uid = n;
    return 0;
}

// pull argument from stack, check range, set process PID
int
sys_setgid(void) {
    int n;
    if (argint(0, &n) < 0) {
        return -1;
    }
    if (n < 0 || n > 32767) {
        return -1;
    }
    proc->gid = n;
    return 0;
}

// pull arguments from stack, pass to proc.c getprocs(uint, struct)
int
sys_getprocs(void) {
    int m;
    struct uproc *u;
    if (argint(0, &m) < 0) {
        return -1;
    }
    // sizeof * MAX
    if (argptr(1, (void*)&u, (sizeof(struct uproc) * m)) < 0) {
        return -1;
    }
    return getprocs(m, u);
}
#endif

#ifdef CS333_P3P4
int
sys_setpriority(void) {
    int n, m;
    // PID argument from stack
    if (argint(0, &n) < 0) {
        return -1;
    }
    // priority argument
    if (argint(1, &m) < 0) {
        return -1;
    }
    // check bounds of PID argument
    if (n < 0 || n > 32767) {
        return -1;
    }
    // check bounds of priority argument
    if (m < 0 || m > MAX) {
        return -1;
    }
    return setpriority(n, m); // pass to user-side
}
#endif
