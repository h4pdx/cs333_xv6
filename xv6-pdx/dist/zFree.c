#ifdef CS333_P3P4
#include "types.h"
#include "user.h"

int main(void) {
    int pid[100];
    int ppid = getpid();

    int i = 0;
    while (i < 100) {
        pid[i] = fork();
        if (ppid != getpid()) {
            for(int x = 0; x < 100000000000; x++); // cycle runnable and ready
            sleep(2000); // put to sleep
            exit();
        }
        if (pid[i] == -1) {
            break;
        }
        i++;
    }

    if (ppid == getpid()) {
        printf(1, "Killed.\n");
        sleep(4000);
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
