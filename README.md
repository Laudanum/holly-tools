# holly-tools

##Local dev

Tools to bootstrap a new local dev website on OS X.

* `_install-tools.sh`: Script to create symlinks from these tools to their correct places in the operating system. **Note: this will delete any existing files.** Please check for useful differences and include them here before running.
* `srv/www/_skel.sh`: Script to create a new dev site
* > usage: `sudo ./_skel.sh example.com`
* > root directory in /srv/www/example.com/local
* > apache config file at /etc/apache/other/25-example.com.conf
* > mysql database named example_local and user called example
* > hosts entry for local.example.com
* `/usr/local/bin/mkpasswd`: Create a password suitable to use for MySQL. Used by `_skel.sh`
* `/etc/apache2/other/_skel.conf.disabled`: A template for creating an Apache config file for a VirtualHost. Used by `_skel.sh`
* `_remove-site.sh`: Reverses the actions of `_skel.sh`. Not symlinked anywhere as it is extremely destructive. Use with caution.

###Manual tasks

* Enable PHP in apache2/httpd.conf
* Enable Rewrite in apache2/httpd.conf
* AllowOverride all for /srv/www

