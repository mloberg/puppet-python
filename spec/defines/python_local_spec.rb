require "spec_helper"

describe "python::local" do
  let(:facts) { default_test_facts }
  let(:title) { '/test/path' }
  let(:params) do
    { :version => "2.7.3" }
  end

  it do
    should include_class("python::2_7_3")

    should contain_file("#{title}/.python-version").with({
      :ensure  => "present",
      :content => "2.7.3\n",
      :replace => true
    })
  end

  context "with invalid version" do
    let(:params) do
      { :version => "no-version" }
    end

    it do
      expect {
        should contain_file("#{title}/.python-version")
      }.to raise_error(Puppet::Error, /Version must be of the form N\.N\.\(\.N\)/)
    end
  end

  context "with ensure absent" do
    let(:params) do
      { :ensure => "absent" }
    end

    it do
      should contain_file("#{title}/.python-version").with_ensure("absent")
    end
  end

  context "with invalid ensure" do
    let(:params) do
      { :ensure => "foo" }
    end

    it do
      expect {
        should contain_file("#{title}/.python-version")
      }.to raise_error(Puppet::Error, /Ensure must be one of present or absent/)
    end
  end
end
