## snapsched-btrfs

#### snapsched is a suite of Bash scripts that will create, manage, and even "backup", scheduled snapshots on a BTRFS Linux file system.

Accidentally delete something you did a couple of hours ago and now it's gone?  Not with this system!  You can restore a file from an hourly, daily, weekly or monthly snapshot quickly and easily.  Yes, it has disk space usage consequences, but that's for the sysadmin to worry about!  Scheduled snapshots are a basic feature for enterprise file products like NetApp and whatnot.  I wanted the same functionality, done my way, so I started writing this.  These days, there are a few Linux packages that can do some of the same stuff, but none of them existed when I started this, and none of them are script-based, so pretty darn hard to customize them in any way.  About a billion years ago, I tried to think, hey, I'm about to do something risky or momentus, I should take a snapshot.  But now I don't have to think anymore.  And the world sighs in relief.

* Exclusively command line interface.  There is no web console or any of that tired nonsense.  But feel free to create one and send me a pull request!

* Works with Linux and btrfs file system specifically

* Handles scheduled snapshots of the hourly, daily, weekly, monthly variety

* Full and correct *mysql* and *postgresql* consistency via database quiescing (OK, *mysql* only.  *postgresql* doesn't seem to need/do that.)

* Uses *cron* to fire snapshots -- meant primarily for mostly-on machines.
  Does not use *anacron*, so results on laptops or workstations that suspend or
  get powered off may not have the expected results in all situations.
  Most noteably with respect to daily, weekly and monthly snapshots that
  may simply not happen at all if the machine is suspended or off.  That said,
  I totally use it on my laptop.  \[note: currently on Debian systems, daily,
  weekly and monthlies are done via *anacron*.  Still though.\]

* Bash shell script based, so fully transparent and customizable.  A meager attempt was made to work with *bash* version prior to 4.3, where some important and extremely useful features were added, but I don't think the backup portions of the code have been carefully examined for this compatibility problem.  I do use this on an old Debian release with *bash* 4.2, but not the backup features.

* Read only snapshots suitable for sending to a secondary machine
  for backup or other purposes.  Manually snap again as RW in
  order to make bootable as root filesystem, or to promote as default
  subvolume for a particular mount point, etc.

### INSTALL
As the **root** user, run ```make``` in the source directory.  It will install the program files and bash completion file(s) in some directory like **/usr/local/sbin**, **/usr/local/lib/snapsched**, etc.  Want them somewhere else?  Just edit the Makefile and change the PREFIX and/or INSTALL_BIN, INSTALL_LIB variables to suit.  The bash completion file is installed in **/etc/bash_completion.d/snapsched**.

### HOWTO

Start by running the command ```snapsched init_config```.  Then, run
the ```snapsched``` command without any arguments, or with -h, and you will get ALL the sub-commands and their usage.  Hopefully you are using a scrolling terminal window.  I try very hard to keep this "self man page" correct and up to date, but beware.  There is a decent, but naked, amount of command completion for a lot of the sub-commands, including the sub-commands themselves.  Also, each sub-command **should** have its own little usage message, which is usually pretty accurate, which you get if the code doesn't like the arguments supplied.  Not all sub-commands take arguments.

### Examples
```snapsched init_config```

Initializes and/or creates the config file **/etc/snapsched/config**.

```snapsched add_source /media/btrfs/@home 24 14 0 0```

Add the subvolume found at **/media/btrfs/@home**.  (/media/btrfs MUST be set up in /etc/fstab to mount subvolid=0 for the btrfs file system.  It is mounted/umounted as needed by each sub-command.)  The *@home* subvolume will be snapped hourly, up to a maximum of 24.  After that, the oldest hourly snapshot will be deleted prior to a new one being created.  **@home** will also be snapped daily up to a maximum of 14 (two weeks).  Weekly and monthly snapshots are disabled.  The snapshots of each interval are done independently, hence the deletion of an hourly does not affect any of the daily snapshots.

```snapsched add_source /media/btrfs/@ 0 0 4 2```

Add the subvolume found at **/media/btrfs/@**. (On Ubuntu, this would usually be the root filesystem)  The *@* subvolume will be snapped weekly, up to a maximum of 4.  *@* will also be snapped monthly up to a maximum of 2.  Hourly and daily snapshots are disabled.  The monthly maximum of two means that if you do something like upgrade to a new release of Debian or Ubuntu, then the large disk usage penalty will only last for a couple of months.  But you still have a couple of months to decide, screw it, and revert to the previous release.  I've done this.  It actually works pretty well!  You must manually snap the snapsched scheduled snapshot to a new, read-write snapshot, ideally with a self-describing name, and then add that to your grub configuration, etc.  Make sure you read up on how to do all that with **btrfs** commands and **grub**.

```snapsched add_source /media/btrfs/@var 24 7 4 2 mysql```

Add the subvolume found at **/media/btrfs/@var**.  Do 24 hourlies, 7 dailies, 4 weeklies, and 2 monthlies.  Let's say you have /var mounted on /media/btrfs/@var, and you have your mysql database files there.  snapsched will attempt to quiesce the database, flushing pending transactions, then perform the snapshot, then releasing it.  The quiescing could be somewhat disruptive to an active mysql database that gets 100s of updates per hour.  In that case, you might be happier disabling hourly snapshots, as your database is moving pretty fast anyway.  But if your database doesn't get a lot of updates, and you're hacking on it and - doh - you screw it up, then - shazam - you can just restore from an hour ago, and no one will be the wiser!
