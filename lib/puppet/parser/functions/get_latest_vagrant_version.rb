require 'json'
require 'open-uri'

module Puppet::Parser::Functions
  newfunction(:get_latest_vagrant_version, :type => :rvalue) do |args|
    # tags = JSON.parse(open('https://api.github.com/repos/mitchellh/vagrant/tags') { |u| u.read })
    # tags.sort_by { |tag| tag['name'] }.last['name'][1..-1]
    JSON.parse(open('http://www.vagrantup.com/latest-version.json') { |u| u.read })["version"]
  end
end
