require 'spec_helper'

describe 'python::global' do
  let(:facts) { default_test_facts }

  it do
    should contain_class("python::2_7_3")

    should contain_file("/test/boxen/pyenv/version").with({
      :ensure  => "present",
      :owner   => "testuser",
      :mode    => "0644",
      :content => "2.7.3\n",
    })
  end

  context "version number given through params" do
    let(:params) do
      {
        :version => "3.3.0"
      }
    end

    it do
      should include_class('python::3_3_0')

      should contain_file("/test/boxen/pyenv/version").
        with_content("3.3.0\n")
    end

  end
end
