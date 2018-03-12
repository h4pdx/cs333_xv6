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
  int mode, rc, valid = 0;
  char *path;
  if ((argv[1][0] == '0') || (argv[1][0] == '1')) {
      if ((argv[1][1] >= '0') && (argv[1][1] <= '7')) {
          if ((argv[1][2] >= '0') && (argv[1][2] <= '7')) {
              if ((argv[1][3] >= '0') && (argv[1][3] <= '7')) {
                  if (!argv[1][4]) {
                      valid = 1; // number is at least 0000 and at most 1777
                  }
              }
          }
      }
  }
  // check validity of argument (could have been 888888)
  if (valid) {
      mode = atoo(argv[1]); // convert octal int
  } else {
      printf(1, "Invalid mode.\n"); // needs to have 2 arguments, along with implicit 1st (3 total)
      exit();
  }
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
