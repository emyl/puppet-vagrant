# Vagrant

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
4. [Usage](#usage)
5. [Limitations](#limitations)

## Overview

Install [vagrant](http://www.vagrantup.com) and, optionally, boxes and plugins.

## Module Description

[Vagrant](http://www.vagrantup.com) is a tool for building and distributing development environments.

## Setup

### What vagrant affects

* vagrant package
* vagrant boxes
* vagrant plugins

### Setup requirements

Since the module relies on some custom facts, you will need to setup `pluginsync = true` on both the master and client node's `/etc/puppet/puppet.conf`.

### Beginning with vagrant

To begin using the vagrant module with default parameters:

`include vagrant`

## Usage

Using the vagrant module consists predominantly in declaring classes that provide desired functionality and features.

### vagrant

Install the vagrant package. If the `version` parameter is not specified, the latest version will be installed.

```
class { 'vagrant':
  version => '1.5.4'
}
```

### vagrant::box

Add a vagrant box under the home directory of the specified user.

```
vagrant::box { 'hashicorp/precise64':
  box_provider => 'virtualbox',
  box_url      => undef,
  user         => 'vagrant'
}
```

### vagrant::plugin

Add a vagrant plugin under the home directory of the specified user.

vagrant::plugin { 'vagrant-lxc':
  user => 'vagrant'
}

## Limitations

The `user` parameter of `vagrant::box` and `vagrant::plugin` is currently
ignored on Windows systems (current user is assumed).
