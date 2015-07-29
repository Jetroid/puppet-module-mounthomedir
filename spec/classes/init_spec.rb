require 'spec_helper'
describe 'mount_homedir' do

  context 'with defaults for all parameters' do
    it { should contain_class('mount_homedir') }
  end
end
