require "spec_helper"

describe "python::package" do
  let(:facts) { default_test_facts }
  let(:title) { "virtualenv for 2.7.6" }

  let(:params) do
    {
      :package => 'virtualenv',
      :version => '1.11.2',
      :python  => '2.7.6',
    }
  end

  it do
    should contain_class("python")

    should contain_pyenv_package("virtualenv for 2.7.6").with({
      :package       => 'virtualenv',
      :version       => '1.11.2',
      :pyenv_root    => '/test/boxen/pyenv',
      :pyenv_version => '2.7.6',
    })
  end
end
