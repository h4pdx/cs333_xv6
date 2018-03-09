#ifdef CS333_P5
#include "types.h"
#include "user.h"

// User command for chgrp system call
// Takes a pathname and a GID argument
// reverses order of arguents for system call
// syscall - chmod(TARGET, GROUP);
// usercmd - chmod GROUP TARGET

int
main(int argc, char **argv) {
    if (argc != 3) {
        printf(1, "Invalid arguments.\n"); // must be 3 - chgrp TARGET GROUP
        exit();
    }
    char * path;
    int group, rc;
    group = atoi(argv[1]); // convert to int GID
    path = argv[2]; // already a char*
    rc = chgrp(path, group); // reverse order for system call
    if (rc < 0) {
        if (rc == -1) {
            printf(1, "chgrp: Invalid pathname.\n");
        }
        else if (rc == -2) {
            printf(1, "chgrp: Invalid GID.\n");
        }
    }
    exit();
}
#endif
