require "spec_helper"

describe "python::3_2" do
  let(:facts) { default_test_facts }

  it do
    should contain_python__version("3.2.5")
  end
end
