#include "types.h"
#include "user.h"

int
main(int argc, char* argv[])
{
  int pid = atoi(argv[1]);
  int priority = atoi(argv[2]);
  setpriority(pid,priority);
  exit();
}
