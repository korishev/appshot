# Appshot

AppShot takes consistent snapshots of your server volumes using pluggable modules for applications, filesystems, and storage providers. One issue with taking snapshots of storage volumes is that without fundamental orchestration at both the application and filesystem level, you are almost certainly not going to get a consistent snapshot.  In-flight data in application and kernel caches will almost certainly be missed, and while you think you are making good backups of your data, when the time comes, you realize that it doesn't work.

The goal for AppShot is to provide a framework for creating pluggable providers for application pausing/restarting, filesystem freezeing/thawing and volume management, whether local (LVM, et. al.) or cloud (Amazon EBS, et. al.)

## Installation

Add this line to your application's Gemfile:

    gem 'appshot'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install appshot

## Usage

Setup your appshot_conf.yml file and run appshot.

    $ bundle exec appshot [appshot name]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
