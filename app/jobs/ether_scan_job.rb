class EtherScanJob < ApplicationJob
  queue_as :default

  def perform
    EtherScanService.call
  end
end
