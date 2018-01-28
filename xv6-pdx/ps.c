#ifdef CS333_P2
#include "types.h"
#include "user.h"
#include "uproc.h"

int
main(int argc, char* argv[])
{
  int utablesize = 0;
  int max = 32;
  int active_uprocs = 0;
  struct uproc* utable;

  if (argc < 0) {
      printf(2, "Invalid input.\n");
      exit();
  }
  if (argc > 1) {
      max = atoi(argv[1]);
  }
  
  utable = (struct uproc*) malloc(max * sizeof(struct uproc));
  utablesize = sizeof(utable);
  printf(1, "Size of utable: %d\n", utablesize); // output at runtime says 4, is this ok?
  printf(1, "utable allocated.\n");  
  active_uprocs = getprocs(max, utable);

  printf(1, "%s = %d\n", " >> ps.c - active_uprocs", active_uprocs);
  if (active_uprocs == -1) {
      printf(1, "Error in active process table creation.\n");
      free(utable);
      exit();
  }
  else if (active_uprocs == 0) {
      printf(1, "No active processes.\n");
      free(utable);
      exit();
  } 
  else if (active_uprocs > 0) {
      for (int i = 0; i < active_uprocs; i++) {
          printf(1, "%s: %s\n", "Process name", utable[i].name);
          //printf(1, "%s: %d\n","Uproc number", i);
      }
  }
  free(utable);
  exit();
}
#endif
