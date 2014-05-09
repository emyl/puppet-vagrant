# == Class: vagrant::params
#
# OS-dependent parameters for vagrant module.
#
class vagrant::params {
  case $::kernel {
    Darwin: {
      $binary = '/usr/bin/vagrant'
      $grep   = '/usr/bin/grep -i'
      $su     = '/usr/bin/su'
    }
    windows: {
      $binary = 'C:\HashiCorp\Vagrant\bin\vagrant.exe'
      $grep   = 'C:\Windows\System32\findstr.exe /I'
    }
    default: {
      $binary = '/usr/bin/vagrant'
      $grep   = '/bin/grep -i'
      $su     = '/bin/su'
    }
  }
}
