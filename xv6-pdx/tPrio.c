#ifdef CS333_P3P4

#include "types.h"
#include "user.h"

int
main(void) {
    int pid, prio;
    int rc;
    pid = getpid();
    printf(1, "Setting priority to 1 (Expected: PASS).\n");
    prio = 1;
    rc = setpriority(pid, prio);
    if (!rc) {
        printf(1, "Priority for process %d set to: %d.\n", pid, prio);
    } else {
        printf(1, "setpriority failed. PID: %d, Priority: %d.\n", pid, prio);
    }
    printf(1, "Sleeping.\n");
    sleep(5000);

    printf(1, "Setting priority to 3 (Expected: PASS).\n");
    prio = 3;
    rc = setpriority(pid, prio);
    if (!rc) {
        printf(1, "Priority for process %d set to: %d.\n", pid, prio);
    } else {
        printf(1, "setpriority failed. PID: %d, Priority: %d.\n", pid, prio);
    }
    printf(1, "Sleeping.\n");
    sleep(5000);

    printf(1, "Setting priority to 100 (Expected: FAIL).\n");
    prio = 100;
    rc = setpriority(pid, prio);
    if (!rc) {
        printf(1, "Priority for process %d set to: %d.\n", pid, prio);
    } else {
        printf(1, "setpriority failed. PID: %d, Priority: %d.\n", pid, prio);
    }
    printf(1, "Sleeping.\n");
    sleep(5000);

    printf(1, "Setting priority to -10 (Expected: FAIL).\n");
    prio = (-10);
    rc = setpriority(pid, prio);
    if (!rc) {
        printf(1, "Priority for process %d set to: %d.\n", pid, prio);
    } else {
        printf(1, "setpriority failed. PID: %d, Priority: %d.\n", pid, prio);
    }
    printf(1, "Sleeping.\n");
    sleep(5000);


    


    exit();
}


#endif
