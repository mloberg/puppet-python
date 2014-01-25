require "spec_helper"

describe "python::3_1_5" do
  let(:facts) { default_test_facts }

  it do
    should contain_python__version("3.1.5")
  end
end
