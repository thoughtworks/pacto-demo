require 'spec_helper'

describe 'Octokit' do

  context 'Repositories', :vcr do

    it 'should include pacto in thoughtworks repos' do
      repository = Octokit.repo 'thoughtworks/pacto'
      expect(repository.name).to eql('pacto')
    end

  end

end