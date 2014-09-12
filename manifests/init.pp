# == Class: vagrant
#
# Install vagrant using the vagrant official packages.
#
# === Parameters
#
# [*version*]
#   The version of the package you want to install. Example: '1.5.4'.
#   If not specified the module will try to get the latest
#   version number from vagrant website.
#
# === Examples
#
#  # Install version 1.5.4
#  class { 'vagrant':
#    version  => '1.5.4'
#  }
#
# === Authors
#
# Emiliano Ticci <emiticci@gmail.com>
#
class vagrant($version = get_latest_vagrant_version()) {

  # The $old_versions hash stores git tag references
  # for versions >= 1.0 and < 1.4
  $old_versions = {
    '1.1.0' => '194948999371e9aee391d13845a0bdeb27e51ac0',
    '1.1.1' => 'f743fed3cc0466839a97d4724ec0995139f87806',
    '1.1.2' => '67bd4d30f7dbefa7c0abc643599f0244986c38c8',
    '1.1.3' => '0903e62add3d6c44ce6ad31ce230f3092be445eb',
    '1.1.4' => '87613ec9392d4660ffcb1d5755307136c06af08c',
    '1.1.5' => '64e360814c3ad960d810456add977fd4c7d47ce6',
    '1.2.0' => 'f5ece47c510e5a632adb69701b78cb6dcbe03713',
    '1.2.1' => 'a7853fe7b7f08dbedbc934eb9230d33be6bf746f',
    '1.2.2' => '7e400d00a3c5a0fdf2809c8b5001a035415a607b',
    '1.2.3' => '95d308caaecd139b8f62e41e7add0ec3f8ae3bd1',
    '1.2.4' => '0219bb87725aac28a97c0e924c310cc97831fd9d',
    '1.2.5' => 'ec2305a9a636ba8001902cecb835a00e71a83e45',
    '1.2.6' => '22b76517d6ccd4ef232a4b4ecbaa276aff8037b8',
    '1.2.7' => '7ec0ee1d00a916f80b109a298bab08e391945243',
    '1.3.0' => '0224c6232394680971a69d94dd55a7436888c4cb',
    '1.3.1' => 'b12c7e8814171c1295ef82416ffe51e8a168a244',
    '1.3.2' => '9a394588a6dcf97e8f916da9564088fcf242c4b3',
    '1.3.3' => 'db8e7a9c79b23264da129f55cf8569167fc22415',
    '1.3.4' => '0ac2a87388419b989c3c0d0318cc97df3b0ed27d',
    '1.3.5' => 'a40522f5fabccb9ddabad03d836e120ff5d14093'
  }

  # Determine the base url (it depends on the version)
  if versioncmp($version, '1.4.0') >= 0 {
    $base_url       = 'https://dl.bintray.com/mitchellh/vagrant'
    $darwin_prefix  = 'vagrant_'
    $windows_prefix = 'vagrant_'
  } else {
    $base_url = "http://files.vagrantup.com/packages/${old_versions[$version]}"
    $darwin_prefix  = 'Vagrant-'
    $windows_prefix = 'Vagrant_'
  }

  # Finally determine download url and provider
  case $::operatingsystem {
    centos, redhat, fedora: {
      case $::architecture {
        x86_64, amd64: {
          $vagrant_source = "${base_url}/vagrant_${version}_x86_64.rpm"
          $vagrant_provider = 'rpm'
        }
        i386: {
          $vagrant_source = "${base_url}/vagrant_${version}_i686.rpm"
          $vagrant_provider = 'rpm'
        }
        default: {
          fail("Unrecognized architecture: ${::architecture}")
        }
      }
    }
    Darwin: {
      $vagrant_source   = "${base_url}/${darwin_prefix}${version}.dmg"
      $vagrant_provider = 'pkgdmg'
    }
    debian, ubuntu, linuxmint: {
      case $::architecture {
        x86_64, amd64: {
          $vagrant_filename = "vagrant_${version}_x86_64.deb"
          $vagrant_provider = 'dpkg'
        }
        i386: {
          $vagrant_filename = "vagrant_${version}_i686.deb"
          $vagrant_provider = 'dpkg'
        }
        default: {
          fail("Unrecognized architecture: ${::architecture}")
        }
      }

      $vagrant_source = "${::ostempdir}/${vagrant_filename}"

      exec { 'vagrant-download':
        command => "/usr/bin/wget -O ${vagrant_source} ${base_url}/${vagrant_filename}",
        creates => $vagrant_source,
        timeout => 0,
        before  => Package["vagrant-${version}"]
      }
    }
    windows: {
      $vagrant_filename = "${windows_prefix}${version}.msi"
      $vagrant_source   = "${::ostempdir}\\${vagrant_filename}"
      $vagrant_provider = 'windows'

      $download_command = "(New-Object Net.WebClient).DownloadFile('${base_url}/${vagrant_filename}', '${vagrant_source}')"

      exec { 'vagrant-download':
        command => "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -ExecutionPolicy Unrestricted -Command \"${download_command}\"",
        creates => $vagrant_source,
        timeout => 0,
        before  => Package["vagrant-${version}"],
      }
    }
    default: {
      fail("Unrecognized operating system: ${::operatingsystem}")
    }
  }

  package { "vagrant-${version}":
    ensure   => present,
    provider => $vagrant_provider,
    source   => $vagrant_source
  }

}
