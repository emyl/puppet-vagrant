# == Define: vagrant::command
#
# Generic interface for a vagrant command.
# Shouldn't be used directly.
#
# === Parameters
#
# [*command*]
#   The command to execute. Default to resource title.
#
# [*unless*]
#   A command used for checking if the resource
#   should run or not.
#
# [*user*]
#   The user under which the command will be execute.
#   Ignored on Windows systems (current user is assumed).
#
define vagrant::command($command = $title, $unless = undef, $user = $::id) {
  include vagrant::params

  if $::vagrantversion == undef {
    include vagrant
  }

  $exec_command = $::kernel ? {
    'windows' => "C:\\Windows\\System32\\cmd.exe /C ${command}",
    default   => "${vagrant::params::su} -l ${user} -c '${command}'"
  }

  if $unless == undef {
    $exec_unless = undef
  } elsif $::kernel == 'windows' {
    $exec_unless = "C:\\Windows\\System32\\cmd.exe /C ${unless}"
  } else {
    $exec_unless = "${vagrant::params::su} -l ${user} -c '${unless}'"
  }

  exec { $exec_command:
    unless  => $exec_unless,
    timeout => 0
  }
}
