require "spec_helper"

describe "python::2_6" do
  let(:facts) { default_test_facts }

  it do
    should contain_python__version("2.6.8")
  end
end
