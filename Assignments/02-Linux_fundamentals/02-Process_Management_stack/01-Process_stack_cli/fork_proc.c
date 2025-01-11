#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>

int main() {
    pid_t pid;

    pid = fork(); 

    if (pid < 0) {
        perror("Fork failed");
        return 1;
    } else if (pid == 0) {
        printf("Child process (PID: %d) is running.\n", getpid());
        sleep(2); 
        printf("Child process (PID: %d) is exiting.\n", getpid());
    } else {
        printf("Parent process (PID: %d) created child (PID: %d).\n", getpid(), pid);
        printf("Parent process is exiting without waiting for child.\n");
    }

    return 0;
}
