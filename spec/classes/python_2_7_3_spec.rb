require "spec_helper"

describe "python::2_7_3" do
  let(:facts) { default_test_facts }

  it do
    should contain_python__version("2.7.3")
  end
end
