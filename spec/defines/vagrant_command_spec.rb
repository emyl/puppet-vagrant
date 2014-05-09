require 'spec_helper'

describe 'vagrant::command' do
  let(:params) { { :unless => 'my-exception', :user => 'myself' } }
  let(:title)  { 'my-command' }

  context 'darwin' do
    let(:facts) do
      {
        :architecture    => 'x86_64',
        :kernel          => 'Darwin',
        :operatingsystem => 'Darwin',
        :vagrantversion  => '1.5.4'
      }
    end

    it do should contain_exec("/usr/bin/su -l myself -c 'my-command'").with(
      'unless'  => "/usr/bin/su -l myself -c 'my-exception'",
      'timeout' => '0'
    ) end
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

    it do should contain_exec("/bin/su -l myself -c 'my-command'").with(
      'unless'  => "/bin/su -l myself -c 'my-exception'",
      'timeout' => '0'
    ) end
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

    it do should contain_exec('C:\Windows\System32\cmd.exe /C my-command').with(
      'unless'  => 'C:\Windows\System32\cmd.exe /C my-exception',
      'timeout' => '0'
    ) end
  end
end
