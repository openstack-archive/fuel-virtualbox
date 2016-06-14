send-sysrq
==========

This tool is a helper for sending Alt+SysRq+<key> combination to the guest OS in VirtualBox VM, which is used in Linux for printing different sorts of debug messages to the kernel log, like list of processes, stack traces of CPUs and so on, or for performing actions: reboot, sync e.t.c. It's very useful when all other ways to communicate to the VM become unavailable.

Please, set sysctl kernel.sysrq to 1 in the guest OS to make all sysrq commands available:

```
sysctl -w kernel.sysrq=1 # in the guest OS
```

### Examples of usage (useful for fuel developers):

* Increase log verbosity:

```
send-sysrq fuel-slave-1 loglevel-7
```

* Print processes information to the kernel log:

```
send-sysrq fuel-slave-1 show-task-states
```

* Print verbose memory usage to the kernel log:

```
send-sysrq fuel-slave-1 show-memory-usage
```

* Print, what system is doing right now:

```
send-sysrq fuel-slave-1 show-registers
```

* More examples:

```
send-sysrq
```
