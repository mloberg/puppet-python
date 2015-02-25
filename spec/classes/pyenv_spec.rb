require "spec_helper"

describe 'python::pyenv' do
  let(:facts) { default_test_facts }

  let(:default_params) do
    {
      :ensure => 'v20141012',
      :prefix => '/test/boxen/pyenv',
      :user   => 'boxenuser',
    }
  end

  let(:params) { default_params }

  it do
    should contain_class('python')

    should contain_repository('/test/boxen/pyenv').with({
      :ensure => 'v20141012',
      :source => 'yyuu/pyenv',
      :user   => 'boxenuser',
    })

    should contain_file('/test/boxen/pyenv/versions').with({
      :ensure => 'symlink',
      :target => '/opt/python',
    })
  end
end
