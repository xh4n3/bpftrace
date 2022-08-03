#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>

int main()
{
  int fd = open("/sys/kernel/debug/tracing/trace", O_WRONLY);
  if (fd < 0)
  {
    printf("Error in open trace buffer path\n");
    return 1;
  }
  close(fd);
  usleep(1000000);
  return 0;
}