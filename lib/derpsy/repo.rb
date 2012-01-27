module Derpsy
  module Repo
    def self.setup
      Derpsy.logger.info "set up repo"
      # git checkout [integration-branch]
      # git pull upstream [integration-branch]
      # git checkout -b derp
      # git fetch [requestor]
      # git merge [requestor] [integration-branch] **** ideally this would be specific commits in request ****
    end
  end
end
