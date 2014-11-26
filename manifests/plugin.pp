# == Define: vagrant::plugin
#
# Add a vagrant plugin under the home directory of the specified user.
#
# === Parameters
#
# [*plugin_name*]
#   The name of the plugin. Default to resource title.
#
# [*user*]
#   The user under which the plugin will be added. Ignored on Windows
#   systems (current user is assumed).
#
define vagrant::plugin(
  $plugin_name    = $title,
  $user           = $::id,
  $plugin_version = undef
) {
  include vagrant::params

  if $plugin_version == undef {
    $plugin_command = "${vagrant::params::binary} plugin install ${plugin_name}"
    $plugin_unless = "${vagrant::params::binary} plugin list | ${vagrant::params::grep} \"^${plugin_name}\s\""
  } else {
    $plugin_command = "${vagrant::params::binary} plugin install ${plugin_name} --plugin-version ${plugin_version}"
    $plugin_unless = "${vagrant::params::binary} plugin list | ${vagrant::params::grep} \"^${plugin_name}\s(${plugin_version})\""
  }

  vagrant::command { "${vagrant::params::binary} plugin install ${plugin_name}":
    unless => $plugin_unless,
    user   => $user,
  }
}
