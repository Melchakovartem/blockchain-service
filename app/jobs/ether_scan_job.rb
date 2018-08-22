class EtherScanJob < ApplicationJob
  queue_as :default

  def perform(*args)
    EtherScanService.call
  end
end
