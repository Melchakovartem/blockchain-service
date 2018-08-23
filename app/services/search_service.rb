class SearchService
  class << self
    REG_HASH = /^0x[a-fA-F0-9]{64}$/
    REG_ADDRESS = /^0x[a-fA-F0-9]{40}$/
    REG_BLOCK = /^[0-9]{1,10}$/
    
    def call(params)
      params.downcase!
      return "Hash", Transaction.find_by_t_hash!(params) if REG_HASH === params
      return "Address", Transaction.where('t_from=? OR t_to=?', params, params) if REG_ADDRESS === params
      return "Block", Block.find_by_b_number!(params) if REG_BLOCK === params
    end
  end
end