require "spec_helper"

describe "python::package" do
  let(:facts) { default_test_facts }
  let(:title) { "virtualenv for 2.7.3" }
  let(:params) do
    { :python_version => "2.7.3", :package => "virtualenv" }
  end

  it do
    should include_class("python::2_7_3")

    should contain_python_package("virtualenv for 2.7.3").with({
      :ensure         => "installed",
      :package        => "virtualenv",
      :python_version => "2.7.3",
      :pyenv_root     => "/test/boxen/pyenv",
      :user           => "testuser",
      :provider       => "pyenv"
    })
  end
end
