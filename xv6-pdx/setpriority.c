#ifdef CS333_P3P4
#include "types.h"
#include "user.h"


// set priority from the xv6 shell
int
main(int argc, char* argv[]) {
    if (argc <= 0) {
        printf(1, "Invaid arguments.\n");
        exit();
    }
    int i, n, rc;
    i = atoi(argv[1]);
    n = atoi(argv[2]);

    rc = setpriority(i, n);
    if (rc < 0) {
        printf(1, "Setpriority failed.\n");
    }
    exit();
}
#endif
