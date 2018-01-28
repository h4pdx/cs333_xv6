#ifdef CS333_P2
#include "types.h"
#include "user.h"
#include "uproc.h"

int
main(void)
{
  int max = 32, active_procs = 0;
  struct uproc* utable;
  utable = (struct uproc*) malloc(max * sizeof(struct uproc));
  // system call -> sysproc.c -> proc.c -> return
  active_procs = getprocs(max, utable); // populate utable
  // error somewhere along the way
  if (active_procs == -1) {
      printf(1, "Error in active process table creation.\n");
      free(utable);
      exit();
  }
  // no active processes
  else if (active_procs == 0) {
      printf(1, "No active processes.\n");
      free(utable);
      exit();
  }
  // loop utable and print process information
  else if (active_procs > 0) {
      for (int i = 0; i < active_procs; i++) {
          printf(1, "%s: %s\n", "Process name", utable[i].name);
      }
  }
  free(utable);
  exit();
}
#endif
