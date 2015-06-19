# holly-tools


## OS X Development Bootstrap

The `osx/` folder contains scripts and tempaltes for standard Holly Development environment. The install script created symlinks from these tools to their correct place in the operating system. 

    `cd osx`
    `./install.sh`

**Note: this will delete any existing files.**

### Adding a new site


    `cd /srv/www/`
    `./add-site.sh domain.com.au`


This will setup and apache config for local.domain.com.au managed by the 


    `/etc/apache/other/25-domain.com.au.conf`

The site root will be:

    `/srv/www/domain.com.au/`

If your are using git repo set it up in:

    `/srv/www/domain.com.au/local/`


@todo add info about DB


Your `/etc/hosts` file will have an entry added to support this site. You should be able to browse the site at:

    `http://local.domain.com.au/`



### Manual tasks (@todo automate these)

* Enable PHP in apache2/httpd.conf
* Enable Rewrite in apache2/httpd.conf


