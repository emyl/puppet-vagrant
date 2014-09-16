# == Define: vagrant::box
#
# Add a vagrant box under the home directory of the specified user.
#
# === Parameters
#
# [*box_name*]
#   The name of the box. Could be in the form 'user/box' if you want
#   to check out the box from Vagrant Cloud, otherwise it accepts an
#   arbitrary string as box name. See also the examples.
#
# [*box_url*]
#   The url of the box. It makes sense only if you're adding a box
#   file directly without using Vagrant Cloud.
#
# [*user*]
#   The user under which the box will be added. Ignored on Windows
#   systems (current user is assumed).
#
define vagrant::box(
  $box_name     = $title,
  $box_provider = undef,
  $box_url      = undef,
  $user         = $::id
) {
  include vagrant::params

  if $box_provider == undef {
    $box_command = "${vagrant::params::binary} box add --clean ${box_name} ${box_url}"
    $box_unless  = "${vagrant::params::binary} box list | ${vagrant::params::grep} \"${box_name}\""
  } else {
    $box_command = "${vagrant::params::binary} box add --clean --provider ${box_provider} ${box_name} ${box_url}"
    $box_unless  = "${vagrant::params::binary} box list | ${vagrant::params::grep} \"${box_name}\" | ${vagrant::params::grep} \"${box_provider}\""
  }

  vagrant::command { "Install box ${box_name} for ${user}":
    command => $box_command,
    unless  => $box_unless,
    user    => $user
  }
}
