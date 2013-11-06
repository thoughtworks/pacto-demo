require 'spec_helper'

describe 'Octokit' do

  context 'Repositories' do

    it 'should include pacto in thoughtworks repos' do
      something = Octokit.repo 'thoughtworks/pacto'
      expect(something.name).to eql('pacto')
    end

  end

end