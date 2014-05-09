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
define vagrant::plugin($plugin_name = $title, $user = $::id) {
  include vagrant::params

  vagrant::command { "${vagrant::params::binary} plugin install ${plugin_name}":
    user => $user
  }
}
