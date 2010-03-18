Shagit
============

Description: A simple web application for local, private git repository management written in Sinatra
Copyright (c) 2009, 2010 Martin Gajdos

released under the MIT license

Introduction
------------

Shagit is a simple web application for managing your local git repositories. There's no need for a database and repositories are being privately published using ssh.

Dependencies
------------

* Sinatra
* Haml
* Grit
* Rack-Test
* Webrat

Installation
------------

You will need a working installation of Ruby >=1.8.6, RubyGems >= 1.3.5 and Git >= 1.5

Clone the repository:

    git clone git://github.com/unabatede/shagit.git

Install the Sinatra, Haml & Grit gems:

    gem install sinatra haml grit rack-test webrat

Run it (you should consider other options for production deployment):

    cd shagit
    ruby shagit.rb -e production

Deployment
----------

Using Apache & Phusion Passenger and the following to a new virtual host file (adjust to suite your needs):

    <VirtualHost *:80>
        DocumentRoot /var/www/shagit/public
        <Directory /var/www/shagit/public>
            Allow from all
            Options -MultiViews
        </Directory>
    </VirtualHost>


Also, inside Shagit's folder, create a 'tmp' and 'public' folder:

    cd /var/www/shagit
    mkdir tmp; mkdir public
