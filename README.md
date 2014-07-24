Altorosdemo
============

The repository contains [Dashing](https://github.com/Shopify/dashing) application build upon [dahsing-rails](https://github.com/gottfrois/dashing-rails) project. 

Application monitors load of Cloud Foundry application and displays common application characteristics (see picture).

![Altorosdemo project dashboard example](https://github.com/Altoros/altorosdemo/raw/master/public/dashboard-example.jpeg "Altorosdemo dashboard example")

Requirements
=============

* Ruby 1.9.3
* Rails 4.1.2
* Redis >= 2.8.4

Redis is used to store information about tasks to update app metrics, it is done so to prevent multiple request to Cloud Foundry after application is scaled to multiple instances.

Configuration
=============

There are two ways to configure application: config file and environment variables. In any case you have to set `REDIS_HOST` environment variable.

To configure application with file you'll need to copy `config/cf.yml.example` file to `config/cf.yml` 
and fill in necessary info. 

In order to configure using environment variables you'll need to specify following variables: 
* `CF_API` - cloud controller address, in common case it will look like `http://api.cf-domain.com`
* `CF_USERNAME` - username that has permissions to fetch application stats
* `CF_PASSWORD` - user password
* `CF_ORGANIZATION` - organization where app is located
* `CF_SPACE` - space where app is located
* `CF_APPLICATION` - application name
* `REDIS_HOST` - (mondatory field) redis server host
* `REDIS_PORT` - redis port, 6379 is used by default

How to run
==========

Define existing Cloud Foundry organization, space and application in configuration, then run `rails s`


Deployment to Cloud Foundry
===========================

To deploy application to Cloud Foundry you will need to create `manifest.yml` from `manifest.yml.example` file. Fill in necessary info and run `cf push`.


Best wishes,
[Alex L](https://github.com/allomov).
