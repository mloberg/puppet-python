require 'spec_helper'

describe 'python::rehash' do
  let(:facts) { default_test_facts }
  let(:root) { "/test/boxen/pyenv" }

  it do
    shared_params = {
      :refreshonly => true,
      :command     => "PYENV_ROOT=#{root} #{root}/bin/pyenv rehash",
      :provider    => "shell",
    }

    should contain_exec("pyenv rehash after python install").with(shared_params)
    should contain_exec("pyenv rehash after python package install").with(shared_params)
  end
end
