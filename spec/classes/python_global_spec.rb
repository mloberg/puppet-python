require 'spec_helper'

describe 'python::global' do
  let(:facts) { default_test_facts }

  context 'system python' do
    let(:params) { {:version => 'system'} }

    it do
      should contain_file('/test/boxen/pyenv/version')
    end
  end

  context 'non-system python' do
    let(:params) { {:version => '2.7.6'} }

    it do
      should contain_file('/test/boxen/pyenv/version').
        that_requires('Python::Version[2.7.6]')
    end
  end
end
