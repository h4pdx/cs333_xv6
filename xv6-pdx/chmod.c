#ifdef CS333_P5
#include "types.h"
#include "user.h"

// User command of chmod()
// Takes a path name and a mode int
// FLIPS the order of the system calls
// syscall - chmod(TARGET, MODE);
// usercmd - chmod MODE TARGET

int
main(int argc, char **argv) {
  if (argc != 3) {
      printf(1, "Invalid arguments.\n"); // needs to have 2 arguments, along with implicit 1st (3 total)
      exit();
  }
  int mode, rc;
  char *path;
  mode = atoo(argv[1]); // convert octal int
  path = argv[2];
  rc = chmod(path, mode); // order is reversed for user cmd - system call
  if (rc < 0) {
      if (rc == -1) {
          printf(1, "chmod: Invalid pathname.\n");
      }
      else if (rc == -2) {
          printf(1, "chmod: Invalid mode.\n");
      }
  }
  exit();
}
#endif
