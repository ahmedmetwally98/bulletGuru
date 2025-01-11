# Linux Processes Commands Excercises

1. List all running processes Use the `ps` command to list all processes running on your system.
`
$ ps aux
`

> See the attached **all_precesses.txt** file

2. Monitor system processes in real-time using `top/htop` command and identify the most CPU-intensive process.

![Diagram](./top-cmd.png)

3. Start a background process. then verif it is still running.
![bg](./figures/3/ps.png)

4. Bring a background process to the foreground
![bg/fg](./figures/4/restore-fg.png)

5. suspend and resume a process
![suspend/resume](./figures/5/stop-resume.png)

6. Kill a process b PID
![Kill proc](./figures/6/6.png)

7. Terminate multiple processes
![erminate proc](./figures/7/7.png)

8. Niceness level

> - Start a command with a low priority using `nice`
> - Check its priority.
> - Change its niceness (priority)
![priority](./figures/8/priority.png)

9. View process hierarchy
![processes hierarch](./figures/9/pstree.png)

10. Redirect process output
![redirect output](./figures/10/ping_out.png)
> check the output file **ping_out.txt**

11. Monitor file descriptor
![file descriptor](./figures/11/file-descriptor.png)


12.  Create and terminate a zombie process
![fork-ptoc-with-no-wait](./figures/13/procfork-roc-with-no-wait)

