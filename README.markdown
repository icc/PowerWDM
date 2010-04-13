# PowerWDM
Powerful Web-based DNS Management for [*PowerDNS*][1].

## Description
PowerWDM is a Ruby on Rails application that provides a multi-user web interface for DNS management.
It works against the database server of a [*PowerDNS*][1] installation with the PostgreSQL backend.
PowerWDM aims to simplify things, not to do them for you. Also PowerWDM will **not** hold your hand 
and take care that you don't break any of your domain zones.

*Please note that this project isn't based on test driven development.*

## Inspiration
The goal of this application is not to meet a demand nor replace existing solutions. Yes, I do know that 
there's many similar solutions out there. This is done as a learning experience, enhancing programming 
skills in Ruby/Rails.

## Instructions
The migration scripts will create all the necessary tables for PowerWDM and [*PowerDNS*][1] to function. 
There will be no modifying existing tables, so start with a clean/new database and point your 
[*PowerDNS*][1] installation to it. 

*More to come later...*

## Plugins
HAML, Gravatar

## Status
Not ready for production.

## License
PowerWDM is licensed under the Simplified BSD License. For more details view LICENSE.

[1]: http://www.powerdns.com/
