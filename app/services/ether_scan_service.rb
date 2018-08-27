class EtherScanService
  class << self


    def call
      @client = EthereumClient.new(Settings.http_path)
      @number = Block.last ? Block.last.b_number.to_i : 0

      while @number > -1 do

        hex_number = @client.int_to_hex(@number)
        block = @client.eth_get_block_by_number(hex_number, nil)["result"]

        if block.nil?
          sleep(5)
          next
        else
          block_record = create_block(block)

          block["transactions"].each do |tr_hash|
            tr = @client.eth_get_transaction_by_hash(tr_hash)["result"]
            create_transaction(tr)
          end
          @number += 1
        end
        
      end
    end
    
    def to_dec(hex)
      hex.to_i(16).to_s(10)
    end

    def create_block(block)
      Block.create(b_number: @number, b_hash: block["hash"], b_parentHash: block["parentHash"], b_mixHash: block["mixHash"],
                      b_nonce: to_dec(block["nonce"]), b_sha3Uncles: block["sha3Uncles"], b_logsBloom: block["logsBloom"], 
                      b_transactionsRoot: block["transactionsRoot"],b_stateRoot: block["stateRoot"], b_receiptsRoot: block["receiptsRoot"], 
                      b_miner: block["miner"], b_difficulty: block["difficulty"], b_totalDifficulty: block["totalDifficulty"], 
                      b_extraData: block["extraData"], b_size: to_dec(block["size"]), b_gasLimit: to_dec(block["gasLimit"]),
                      b_gasUsed: to_dec(block["gasUsed"]), b_timestamp: to_dec(block["timestamp"]), b_transactions: block["transactions"].to_a)
    end

    def create_transaction(tr)
      Transaction.create(t_hash: tr["hash"], t_nonce: to_dec(tr["nonce"]), t_blockHash: tr["blockHash"], 
                         t_blockNumber: @number, t_transactionIndex: tr["transactionIndex"], t_from: tr["from"], 
                         t_to: tr["to"], t_value: to_dec(tr["value"]), t_gas: to_dec(tr["gas"]), 
                         t_gasPrice: to_dec(tr["gasPrice"]), t_input: tr["input"], t_contract_address: get_contract_address(tr["hash"]))
    end

    def get_contract_address(hash)
      @client.eth_get_transaction_receipt(hash)["result"]["contractAddress"]
    end
  end
end