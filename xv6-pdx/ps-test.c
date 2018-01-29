// helper file to test requirements for ps command

#ifdef CS333_P2
#include "types.h"
#include "user.h"

void
forktest(int N)
{
  int n, pid;

  printf(1, "starting fork test\n");

  for(n=0; n<N; n++){
    pid = fork();
    if(pid < 0)
      break;
    if(pid == 0) {
      sleep(10*TPS);
      exit();
    }
  }

  printf(2, "checking for %d child processes.\n", n);

  for(; n > 0; n--){
    if(wait() < 0){
      printf(2, "wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
    printf(2, "wait got too many\n");
    exit();
  }

  printf(1, "fork test OK\n");
}

int
main(int argc, char **argv)
{
  int N;

  if (argc == 1) {
    printf(2, "Enter number of processes to create\n");
    exit();
  }

  N = atoi(argv[1]);
  forktest(N);
  exit();
}
#endif
