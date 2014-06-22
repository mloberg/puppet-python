require 'spec_helper'

describe 'python' do
  let(:facts) { default_test_facts }

  let(:default_params) do
    {
      :pyenv_plugins    => {},
      :pyenv_version    => 'v20140615',
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
      :ensure => 'v20140615',
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

    should contain_python__plugin('pyenv-pip-rehash').with({
      :ensure => 'v0.0.4',
      :source => 'yyuu/pyenv-pip-rehash',
    })
  end

  context "not darwin" do
    let(:facts) { default_test_facts.merge(:osfamily => "Linux") }

    it do
      should_not include_class("boxen::config")

      should_not contain_file('/test/boxen/env.d/pyenv.sh').
        with_source('puppet:///modules/python/pyenv.sh')
    end
  end

  context "pyenv plugins" do
    let(:params) do
      default_params.merge(
        :pyenv_plugins => {
          'pyenv-virtualenv' => {
            'ensure' => 'v20140123',
            'source' => 'yyuu/pyenv-virtualenv',
          }
        }
      )
    end

    it do
      should contain_python__plugin('pyenv-virtualenv').with({
        :ensure => 'v20140123',
        :source => 'yyuu/pyenv-virtualenv',
      })
    end
  end
end
