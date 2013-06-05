require "spec_helper"

describe "python::3_3" do
  let(:facts) { default_test_facts }

  it do
    should contain_python__version("3.3.0")
  end
end
