require 'rails_helper'

RSpec.describe Owner, type: :model do
  it { should have_one(:ethereum_wallet) }
end
