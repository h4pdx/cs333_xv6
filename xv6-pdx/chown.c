#ifdef CS333_P5
#include "types.h"
#include "user.h"

// User command for system call chown
// takes a pathname and a UID argument
// Argument order is reversed for syscall
// syscall - chown(TARGET, OWNER);
// usercmd - chown OWNER TARGET

int
main(int argc, char **argv) {
    if (argc != 3) {
        printf(1, "Invalid arguments.\n"); // no more, no less, than 3
        exit();
    }
    char * path;
    int owner, rc;
    owner = atoi(argv[1]); // convert to int
    path = argv[2]; // already a char*
    rc = chown(path, owner); // Arg order is reveresed for system call
    if (rc < 0) {
        if (rc == -1) {
            printf(1, "chown: Invalid pathname.\n");
        }
        else if (rc == -2) {
            printf(1, "chown: Invalid UID.\n");
        }
    }   
    exit();
}
#endif
