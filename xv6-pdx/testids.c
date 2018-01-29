#ifdef CS333_P2

#include "types.h"
#include "user.h"

int
testuidgid(void) {
    uint uid, gid, ppid;

    uid = getuid();
    printf(2, "Current UID: %d\n", uid);
    
    // test setting uid and getting again
    printf(2, "Setting UID to 100...\n");
    if (setuid(100) == 0) {
        printf(2, "UID set.\n");
    }
    uid = getuid();
    printf(2, "UID updated: %d\n", uid);

    // test getting set gid
    gid = getgid();
    printf(2, "Current GID: %d\n", gid);

    // test gid setting and getting
    printf(2, "Setting GID to 100...\n");
    if (setgid(100) == 0) {
        printf(2, "GID set.\n");
    }
    gid = getgid();
    printf(2, "GID updated: %d\n", gid);

    // testprocess
    ppid = getppid();
    printf(2, "Parent Process ID: %d\n", ppid);

    // test proper failure 
    printf(2, "Setting current UID to 33000 (max is 32767).\n");
    if (setuid(33000) < 0) {
        printf(2, "Proper error code returned.\n");
        if (getuid() == 0) {
            printf(2, "UID set to 0 after error.\n");
        }
    }

    // test proper failures
    printf(2, "Setting current GID to 33000 (max is 32767).\n");
    if (setgid(33000) < 0) {
        printf(2, "Proper error code returned.\n");
        if (getgid() == 0) {
            printf(2, "GID set to 0 after error.\n");
        }
    }
    printf(2, "Done!\n");
    exit();
}
#endif
