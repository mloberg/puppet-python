require 'spec_helper'

describe 'python' do
  let(:facts) { default_test_facts }

  let(:default_params) do
    {
      :default_packages => [],
      :pyenv_plugins    => {},
      :pyenv_version    => 'v0.4.0-20131217',
      :pyenv_root       => '/test/boxen/pyenv',
      :user             => 'boxenuser',
    }
  end

  let(:params) { default_params }

  it do
    should include_class("python::params")
    should include_class("boxen::config")

    should contain_package("readline").with({
      :ensure => 'latest',
    })

    should contain_repository('/test/boxen/pyenv').with({
      :ensure => 'v0.4.0-20131217',
      :source => 'yyuu/pyenv',
      :user   => 'boxenuser',
    })

    should contain_file('/test/boxen/pyenv/versions').with_ensure('directory')
    should contain_file('/test/boxen/pyenv/shims').with_ensure('directory')
    should contain_file('/test/boxen/pyenv/pyenv.d').with_ensure('directory')
    should contain_file('/test/boxen/pyenv/pyenv.d/install').
      with_ensure('directory')

    should contain_file('/test/boxen/env.d/pyenv.sh').with_ensure("absent")
    should contain_boxen__env_script("pyenv")
  end

  context "not darwin" do
    let(:facts) { default_test_facts.merge(:osfamily => "Linux") }

    it do
      should_not include_class("boxen::config")

      should_not contain_file('/test/boxen/env.d/pyenv.sh').
        with_source('puppet:///modules/python/pyenv.sh')
    end
  end
end
