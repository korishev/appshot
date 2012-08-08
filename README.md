# Appshot

AppShot takes consistent snapshots of your server volumes using pluggable modules for applications, filesystems, and storage providers. One issue with taking snapshots of storage volumes is that without fundamental orchestration at both the application and filesystem level, you are almost certainly not going to get a consistent snapshot.  In-flight data in application and kernel caches will likely be missed, and while you think you are making good backups of your data, when the time comes, you realize that it doesn't work.

The goal for AppShot is to provide a framework for creating pluggable providers for application pausing/restarting, filesystem freezeing/thawing and volume management, whether local (LVM, et. al.) or cloud (Amazon EBS, et. al.).  The software isn't quite there yet, but progress is being made.

MySQL is supported as an app, but it this gem doesn't install the mysql2 gem for you.  You'll need to do that if you
want to use the MySQL app functions.

Currently only supports some Device Mapper filesystems for freezing (ext4, XFS), Mysql as an application, and Amazon EBS as the volume store.  More on the way.

Support for ext3, ReiserFS and JFS in filesystem freezing should be a trivial method alias, but I haven't had time to test them.  Filesystem freezing is unnecessary when using LMV2's volume snapshot capability (the underlying device-mapper provides this functionality for free), but I haven't implemented LVM2 snapshots yet.

As always, patches welcome.  I don't have much access or experience with anything but linux or OS X, so patches for any flavor of BSD or (Open)Solaris gratefully accepted.

## Installation

  $ gem install appshot

## Usage

Setup your appshot.conf file and run appshot.

    $ appshot

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
