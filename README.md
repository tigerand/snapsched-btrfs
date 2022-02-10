## snapsched-btrfs

#### snapsched is a suite of Bash scripts that will create and manage, and even "backup", scheduled snapshots on a BTRFS Linux file system.

Accidentally delete something you did a couple of hours ago and now it's gone?  Not with this system!  You can restore a file from an hourly, daily, weekly or monthly snapshot quickly and easily.  Yes, it has disk space usage consequences, but that's for the sysadmin to worry about!  Scheduled snapshots are a basic feature for enterprise file products like NetApp and whatnot.  I wanted the same functionality, done my way, so I started writing this.  These days, there are a few Linux packages that can do some of the same stuff, but none of them existed when I started this, and none of them are script-based, so pretty darn hard to customize them in any way.

* Works with Linux and btrfs file system specifically

* Handles scheduled snapshots of the hourly, daily, weekly, monthly variety

* Full and correct *mysql* and *postgresql* consistency via database quiescing (OK, *postgresql*.  *mysql* doesn't seem to need/do that.)

* Uses *cron* to fire snapshots -- meant primarily for mostly-on machines.
  Does not use *anacron*, so results on laptops or workstations that suspend or get
  powered off may have not have expected results in all situations.
  Most noteably with respect to daily, weekly and monthly snapshots that
  may simply not happen at all if machine is suspended or off.
  \[note: currently on Debian systems, daily, weekly and monthlies are
  done via *anacron*.  Still though.\]

* Bash shell script based, so fully transparent and customizable.  A meager attempt was made to work with *bash* version prior to 4.3, where some important and extremely useful features were added, but I don't think the backup portions of the code have been carefully examined for this compatibility problem.  I do use this on an old Debian release with *bash* 4.2, but not the backup features.

* Read only snapshots suitable for sending to a secondary machine
  for backup or other purposes.  Can also be snapped again as RW in
  order to make bootable as root filesystem, or to promote as default
  subvolume for a particular mount point, etc.

### INSTALL
As the **root** user, run ```make``` in the source directory.  It will install the program files and bash completion file(s) in some directory like **/usr/local/sbin**.  Want them somewhere else?  Just edit the Makefile and change the PREFIX and/or INSTALL_BIN, INSTALL_LIB variables to suit.  The bash completion file is installed in **/etc/bash_completion.d/snapsched**

### HOWTO

run the *snapsched* command without any arguments, or with -h, and you will get ALL the sub-commands and their usage.  Hopefully it is correct.  There is a decent, but naked, amount of command completion.
