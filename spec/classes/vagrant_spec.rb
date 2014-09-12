require 'spec_helper'

describe 'vagrant' do
  context 'rpm' do
    ['centos', 'redhat', 'fedora'].each do |distro|
      context 'x64' do
        ['x86_64', 'amd64'].each do |arch|
          let(:facts) { { :architecture => arch, :operatingsystem => distro } }
          context 'version < 1.4' do
            let(:params) { { :version => '1.1.0' } }
            it do should contain_package('vagrant-1.1.0').with(
              'ensure'   => 'present',
              'provider' => 'rpm',
              'source'   => 'http://files.vagrantup.com/packages/194948999371e9aee391d13845a0bdeb27e51ac0/vagrant_1.1.0_x86_64.rpm'
            ) end
          end
          context 'version >= 1.4' do
            let(:params) { { :version => '1.4.0' } }
            it do should contain_package('vagrant-1.4.0').with(
              'ensure'   => 'present',
              'provider' => 'rpm',
              'source'   => 'https://dl.bintray.com/mitchellh/vagrant/vagrant_1.4.0_x86_64.rpm'
            ) end
          end
        end
      end
      context 'x86' do
        let(:facts) { { :architecture => 'i386', :operatingsystem => distro } }
        context 'version < 1.4' do
          let(:params) { { :version => '1.1.0' } }
          it do should contain_package('vagrant-1.1.0').with(
            'ensure'   => 'present',
            'provider' => 'rpm',
            'source'   => 'http://files.vagrantup.com/packages/194948999371e9aee391d13845a0bdeb27e51ac0/vagrant_1.1.0_i686.rpm'
          ) end
        end
        context 'version >= 1.4' do
          let(:params) { { :version => '1.4.0' } }
          it do should contain_package('vagrant-1.4.0').with(
            'ensure'   => 'present',
            'provider' => 'rpm',
            'source'   => 'https://dl.bintray.com/mitchellh/vagrant/vagrant_1.4.0_i686.rpm'
          ) end
        end
      end
    end
  end
  context 'deb' do
    ['debian', 'ubuntu', 'linuxmint'].each do |distro|
      context 'x64' do
        ['x86_64', 'amd64'].each do |arch|
          let(:facts) { { :architecture => arch, :operatingsystem => distro, :ostempdir => '/tmp' } }
          context 'version < 1.4' do
            let(:params) { { :version => '1.1.0' } }
            it do should contain_exec('vagrant-download').with(
              'command' => '/usr/bin/wget -O /tmp/vagrant_1.1.0_x86_64.deb http://files.vagrantup.com/packages/194948999371e9aee391d13845a0bdeb27e51ac0/vagrant_1.1.0_x86_64.deb',
              'creates' => '/tmp/vagrant_1.1.0_x86_64.deb',
              'timeout' => '0'
            ) end
            it do should contain_package('vagrant-1.1.0').with(
                'ensure'   => 'present',
                'provider' => 'dpkg',
                'source'   => '/tmp/vagrant_1.1.0_x86_64.deb'
            ) end
          end
          context 'version >= 1.4' do
            let(:params) { { :version => '1.4.0' } }
            it do should contain_exec('vagrant-download').with(
              'command' => '/usr/bin/wget -O /tmp/vagrant_1.4.0_x86_64.deb https://dl.bintray.com/mitchellh/vagrant/vagrant_1.4.0_x86_64.deb',
              'creates' => '/tmp/vagrant_1.4.0_x86_64.deb',
              'timeout' => '0'
            ) end
            it do should contain_package('vagrant-1.4.0').with(
                'ensure'   => 'present',
                'provider' => 'dpkg',
                'source'   => '/tmp/vagrant_1.4.0_x86_64.deb'
            ) end
          end
        end
      end
      context 'x86' do
        let(:facts) { { :architecture => 'i386', :operatingsystem => distro, :ostempdir => '/tmp' } }
        context 'version < 1.4' do
          let(:params) { { :version => '1.1.0' } }
          it do should contain_exec('vagrant-download').with(
            'command' => '/usr/bin/wget -O /tmp/vagrant_1.1.0_i686.deb http://files.vagrantup.com/packages/194948999371e9aee391d13845a0bdeb27e51ac0/vagrant_1.1.0_i686.deb',
            'creates' => '/tmp/vagrant_1.1.0_i686.deb',
            'timeout' => '0'
          ) end
          it do should contain_package('vagrant-1.1.0').with(
              'ensure'   => 'present',
              'provider' => 'dpkg',
              'source'   => '/tmp/vagrant_1.1.0_i686.deb'
          ) end
        end
        context 'version >= 1.4' do
          let(:params) { { :version => '1.4.0' } }
          it do should contain_exec('vagrant-download').with(
            'command' => '/usr/bin/wget -O /tmp/vagrant_1.4.0_i686.deb https://dl.bintray.com/mitchellh/vagrant/vagrant_1.4.0_i686.deb',
            'creates' => '/tmp/vagrant_1.4.0_i686.deb',
            'timeout' => '0'
          ) end
          it do should contain_package('vagrant-1.4.0').with(
              'ensure'   => 'present',
              'provider' => 'dpkg',
              'source'   => '/tmp/vagrant_1.4.0_i686.deb'
          ) end
        end
      end
    end
  end
  context 'darwin' do
    let(:facts) { { :operatingsystem => 'Darwin' } }
    context 'version < 1.4' do
      let(:params) { { :version => '1.1.1' } }
      it do should contain_package('vagrant-1.1.1').with(
        'ensure'   => 'present',
        'provider' => 'pkgdmg',
        'source'   => 'http://files.vagrantup.com/packages/f743fed3cc0466839a97d4724ec0995139f87806/Vagrant-1.1.1.dmg'
      ) end
    end
    context 'version >= 1.4' do
      let(:params) { { :version => '1.4.1' } }
      it do should contain_package('vagrant-1.4.1').with(
        'ensure'   => 'present',
        'provider' => 'pkgdmg',
        'source'   => 'https://dl.bintray.com/mitchellh/vagrant/vagrant_1.4.1.dmg'
      ) end
    end
  end
  context 'windows' do
    let(:facts) { { :operatingsystem => 'windows', :ostempdir => 'C:\Users\Administrator\AppData\Local\Temp' } }
    context 'version < 1.4' do
      let(:params) { { :version => '1.1.1' } }
      it do should contain_exec('vagrant-download').with(
        'command' => "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -ExecutionPolicy Unrestricted -Command \"(New-Object Net.WebClient).DownloadFile('http://files.vagrantup.com/packages/f743fed3cc0466839a97d4724ec0995139f87806/Vagrant_1.1.1.msi', 'C:\\Users\\Administrator\\AppData\\Local\\Temp\\Vagrant_1.1.1.msi')\"",
        'creates' => 'C:\Users\Administrator\AppData\Local\Temp\Vagrant_1.1.1.msi',
        'timeout' => '0'
      ) end
      it do should contain_package('vagrant-1.1.1').with(
          'ensure'   => 'present',
          'provider' => 'windows',
          'source'   => 'C:\Users\Administrator\AppData\Local\Temp\Vagrant_1.1.1.msi'
      ) end
    end
    context 'version >= 1.4' do
      let(:params) { { :version => '1.4.1' } }
      it do should contain_exec('vagrant-download').with(
        'command' => "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -ExecutionPolicy Unrestricted -Command \"(New-Object Net.WebClient).DownloadFile('https://dl.bintray.com/mitchellh/vagrant/vagrant_1.4.1.msi', 'C:\\Users\\Administrator\\AppData\\Local\\Temp\\vagrant_1.4.1.msi')\"",
        'creates' => 'C:\Users\Administrator\AppData\Local\Temp\vagrant_1.4.1.msi',
        'timeout' => '0'
      ) end
      it do should contain_package('vagrant-1.4.1').with(
          'ensure'   => 'present',
          'provider' => 'windows',
          'source'   => 'C:\Users\Administrator\AppData\Local\Temp\vagrant_1.4.1.msi'
      ) end
    end
  end
end
