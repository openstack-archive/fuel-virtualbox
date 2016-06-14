add-slave-node-and-boot
=======================

* This script is used for the debugging purposes to create and boot the new
  slave node with same settings used in the latest one by number (clone it).

* To remove accidentialy added node from the list this command should be used
  (in this example 99 is the node id):

```
fuel node --node-id 99 --delete-from-db --force
```

* This script should be executed from the root fuel-virtualbox scripts
  directory.
