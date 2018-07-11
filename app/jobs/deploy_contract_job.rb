class DeployContractJob < ApplicationJob
  queue_as :default

  def perform(profile_id, referrer_profile_id)
    DeployContractService.call(profile_id, referrer_profile_id)
  end
end
