require "spec_helper"

describe 'python::plugin' do
  let(:facts) { default_test_facts }

  let(:title) { "pyenv-virtualenv" }

  let(:params) do
    {
      :ensure => "v20140123",
      :source => "yyuu/pyenv-virtualenv",
    }
  end

  it do
    should contain_class("python")

    should contain_repository("/test/boxen/pyenv/plugins/pyenv-virtualenv").with({
      :ensure => "v20140123",
      :source => "yyuu/pyenv-virtualenv"
    })
  end
end
