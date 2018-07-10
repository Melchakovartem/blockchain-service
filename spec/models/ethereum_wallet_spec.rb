require 'rails_helper'

RSpec.describe EthereumWallet, type: :model do
  it { should belong_to(:userable) }
end
