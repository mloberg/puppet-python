require "spec_helper"

describe "python::version" do
  let(:facts) { default_test_facts }
  let(:title) { "2.7.3" }

  it do
    should include_class("python")

    should contain_python("2.7.3").with({
      :ensure  => "present"
    })
  end

  context "non-default parameter values" do
    let(:params) do
      { :ensure => "absent", :version => "2.6.8" }
    end

    it do
      should contain_python("2.6.8").with({
        :ensure  => "absent",
        :version => "2.6.8"
      })
    end
  end
end
