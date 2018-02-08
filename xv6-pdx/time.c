#ifdef CS333_P2
#include "types.h"
#include "user.h"

int
main(int argc, char * argv[])
{
    if (argc <= 0) {
        exit();
    }
    uint start_time = 0, end_time = 0, pid = 0, elapsed_time = 0, sec = 0, milisec_ten = 0, milisec_hund = 0;
    if (argc == 1) {
        printf(1, "%s ran in 0.00 seconds\n", argv[0]);
        exit();
    }
    start_time = uptime(); // start uptime
    pid = fork(); // fork new process
    if (pid > 0) {
        pid = wait(); // wait for child to finish
    }
    else if (pid == 0) {
        exec(argv[1], (argv+1)); // pointer arithmetic to skip first index of argv (always will be time)
        exit();
    }
    end_time = uptime(); // record end time
    elapsed_time = (end_time - start_time); // calc elapsed time
    sec = (elapsed_time / 1000); // divide for whole seconds
    milisec_ten = ((elapsed_time %= 1000) / 100); // mod and divide for miliseconds
    milisec_hund = ((elapsed_time %= 100) / 10);

    printf(1, "%s ran in %d.%d%d seconds\n", argv[1], sec, milisec_ten, milisec_hund);
    exit();
}

#endif
