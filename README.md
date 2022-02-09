* works with Linux and btrfs file system specifically

* handles scheduled snapshots of the hourly, daily, weekly, monthly variety

* full and correct mysql and postgresql consistency via database quiescing

* uses cron to fire snapshots -- meant primarily for mostly-on machines.
  does not use anacron, so results on laptops or workstations that get
  powered off may have not have expected results in all situations.
  Most noteably with respect to daily, weekly and monthly snapshots that
  may simply not happen at all if machine is sleeping or off.
  [note: currently on debian systems, daily, weekly and monthlies are
  done via anacron]

* shell script based, so fully transparent and customizable

* read only snapshots suitable for sending to a secondary machine
  for backup or other purposes.  can also be snapped again as rw in
  order to make bootable as root filesystem, or to promote as default
  subvolume for a particular mount point
