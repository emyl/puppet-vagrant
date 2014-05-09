require 'spec_helper'

describe 'vagrant::box' do
  let(:title)  { 'my-box' }

  context 'darwin' do
    let(:facts) do
      {
        :architecture    => 'x86_64',
        :kernel          => 'Darwin',
        :operatingsystem => 'Darwin',
        :vagrantversion  => '1.5.4'
      }
    end

    it { should contain_class('vagrant::params') }

    context 'with an explicit provider' do
      let(:params) { { :box_url => 'my-box-url', :box_provider => 'my-provider'} }
      it do should contain_vagrant__command(
        '/usr/bin/vagrant box add --clean --provider my-provider my-box my-box-url'
      ).with_unless(
        '/usr/bin/vagrant box list | /usr/bin/grep -i "my-box" | /usr/bin/grep -i "my-provider"'
      ) end
    end

    context 'without an explicit provider' do
      let(:params) { { :box_url => 'my-box-url' } }
      it do should contain_vagrant__command(
        '/usr/bin/vagrant box add --clean my-box my-box-url'
      ).with_unless(
        '/usr/bin/vagrant box list | /usr/bin/grep -i "my-box"'
      ) end
    end
  end

  context 'linux' do
    let(:facts) do
      {
        :architecture    => 'i386',
        :kernel          => 'Linux',
        :operatingsystem => 'debian',
        :vagrantversion  => '1.5.4'
      }
    end

    it { should contain_class('vagrant::params') }

    context 'with an explicit provider' do
      let(:params) { { :box_url => 'my-box-url', :box_provider => 'my-provider'} }
      it do should contain_vagrant__command(
        '/usr/bin/vagrant box add --clean --provider my-provider my-box my-box-url'
      ).with_unless(
        '/usr/bin/vagrant box list | /bin/grep -i "my-box" | /bin/grep -i "my-provider"'
      ) end
    end

    context 'without an explicit provider' do
      let(:params) { { :box_url => 'my-box-url' } }
      it do should contain_vagrant__command(
        '/usr/bin/vagrant box add --clean my-box my-box-url'
      ).with_unless(
        '/usr/bin/vagrant box list | /bin/grep -i "my-box"'
      ) end
    end

    context 'with an explicit user' do
      let(:params) { { :box_url => 'my-box-url', :user => 'myself' } }
      it { should contain_vagrant__command('/usr/bin/vagrant box add --clean my-box my-box-url').with_user('myself') }
    end
  end

  context 'windows' do
    let(:facts) do
      {
        :architecture    => 'x64',
        :kernel          => 'windows',
        :operatingsystem => 'windows',
        :vagrantversion  => '1.5.4'
      }
    end

    context 'with an explicit provider' do
      let(:params) { { :box_url => 'my-box-url', :box_provider => 'my-provider'} }
      it do should contain_vagrant__command(
        'C:\HashiCorp\Vagrant\bin\vagrant.exe box add --clean --provider my-provider my-box my-box-url'
      ).with_unless(
        'C:\HashiCorp\Vagrant\bin\vagrant.exe box list | C:\Windows\System32\findstr.exe /I "my-box" | C:\Windows\System32\findstr.exe /I "my-provider"'
      ) end
    end

    context 'without an explicit provider' do
      let(:params) { { :box_url => 'my-box-url'} }
      it do should contain_vagrant__command(
        'C:\HashiCorp\Vagrant\bin\vagrant.exe box add --clean my-box my-box-url'
      ).with_unless(
        'C:\HashiCorp\Vagrant\bin\vagrant.exe box list | C:\Windows\System32\findstr.exe /I "my-box"'
      ) end
    end
  end
end
