require 'spec_helper'

describe 'vagrant::plugin' do
  let(:title) { 'my-plugin' }

  context 'windows' do
    let(:facts) do
      {
        :architecture    => 'x64',
        :kernel          => 'windows',
        :operatingsystem => 'windows',
        :vagrantversion  => '1.5.4'
      }
    end

    it { should contain_vagrant__command('C:\HashiCorp\Vagrant\bin\vagrant.exe plugin install my-plugin') }
  end

  context 'default' do
    let(:facts) do
      {
        :architecture    => 'i386',
        :kernel          => 'Linux',
        :operatingsystem => 'debian',
        :vagrantversion  => '1.5.4'
      }
    end

    it { should contain_class('vagrant::params') }

    it { should contain_vagrant__command('/usr/bin/vagrant plugin install my-plugin') }

    context 'with an explicit user' do
      let(:params) { { :user => 'vagrant' } }
      it { should contain_vagrant__command('/usr/bin/vagrant plugin install my-plugin').with_user('vagrant') }
    end
  end
end
