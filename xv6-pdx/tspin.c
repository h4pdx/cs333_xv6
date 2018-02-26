#ifdef CS333_P3P4
#include "types.h"
#include "user.h"
#include "param.h"

int
main(void) {
    int i = 0, j;
    while (i < 5) {
        j = fork();
        setpriority(getpid(), MAX);
        if (!j) {
            for(;;);
        }
        ++i;
    }
    setpriority(getpid(), MAX);
    for(;;);
    exit();
}
#endif
