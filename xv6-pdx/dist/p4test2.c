#include "types.h"
#include "user.h"
// test program provided by Professor Morrissey
#define PrioCount 1
#define numChildren 5

void
countForever(int i)
{
    int j, p, rc;
    unsigned long count = 0;

    j = getpid();
    p = i%PrioCount;
    rc = setpriority(j, p);
    if (rc == 0) 
        printf(1, "%d: start prio %d\n", j, p);
    else {
        printf(1, "setpriority failed. file %s at %d\n", __FILE__, __LINE__);
        exit();
    }

    while (1) {
        count++;
        if ((count & (0x1FFFFFFF)) == 0) {
            p = (p+1) % PrioCount;
            rc = setpriority(j, p);
            if (rc == 0) 
                printf(1, "%d: new prio %d\n", j, p);
            else {
                printf(1, "setpriority failed. file %s at %d\n", __FILE__, __LINE__);
                exit();
            }
        }
    }
}

    int
main(void)
{
    int i, rc;

    for (i=0; i<numChildren; i++) {
        rc = fork();
        if (!rc) { // child
            countForever(i);
        }
    }
    // what the heck, let's have the parent waste time as well!
    countForever(1);
    exit();
}

