#ifdef CS333_P3P4
#include "types.h"
#include "user.h"

int
main(void) {

// fork a bunch of infinite loops
    int pid[5];
    int ppid = getpid();
    int i = 0;
    //int rc;
    while (i < 100) {
        pid[i] = fork();
        setpriority(pid[i], 2);
        if (ppid != getpid()) {
            //for(int x = 0; x < 100000000000; x++); // cycle runnable and ready
            sleep(10000); // put to sleep
            /*
            for(;;) {
                rc = setpriority(getpid(), i);
                if (!rc) {
                    sleep(2500);
                }
                else {
                    printf(1, "Prio not set.\n");
                }
            }
            */
            exit();
        }
        if (pid[i] == -1) {
            break;
        }
        i++;
    }

    if (ppid == getpid()) {
        //for(;;);
        /*
        for(;;) {
            rc = setpriority(getpid(), i);
            if (!rc) {
                sleep(2500);
            }
        }
        */
        printf(1, "Killed.\n");
        sleep(10000);
        int j = 0;
        while (j < 64) {
            kill(pid[j]);
            sleep(2000);
            while (wait() == -1) {}
            printf(1, "Reaped %d.\n", pid[j]);
            j++;
        }
    }
    exit();
}
#endif
