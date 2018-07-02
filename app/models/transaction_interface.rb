class TransactionInterface
  class << self
    # transfer NOS from address to address
    def transfer(address)
      value = ENV['NOS_VALUE']
      hex_value = integer_to_hex(value)
      cita_url = ENV['CITA_URL']
      private_key = ENV['PRIVATE_KEY']
      resp = `cita-cli transfer  --address #{address} --private-key #{private_key} --value #{hex_value} --quota 1000000 --url #{cita_url}`
      json = JSON.parse(resp)
      result = json["result"]
      [result['hash'], result["status"]]
    end

    def transfer_value(value)
      (value.to_d * (10 ** 18)).to_i.to_s
    end

    def integer_to_hex(value)
      "0x0" + transfer_value(value).to_i.to_s(16)
    end

    def is_address(address)
      if /^(0x)?[0-9a-f]{40}$/i !~ address
        false
      elsif /^(0x)?[0-9a-f]{40}$/ =~ address || /^(0x)?[0-9A-F]{40}$/ =~ address
        true
      else
        is_checksum_address(address)
      end
    end

    def is_checksum_address(address)
      address_value = address.sub(/^0x/i,'')
      address_hash = sha3(address_value.downcase).sub(/^0x/i, '')
      (0...40).each do |i|
        if (address_hash[i].to_i(16) > 7 && address_value[i].upcase != address_value[i]) || (address_hash[i].to_i(16) <= 7 && address_value[i].downcase != address_value[i])
          return false
        end
      end
      true
    end

    SHA3_NULL_S = '0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470'
    def sha3(value)
      if is_hex_strict(value) && /^0x/i =~ value.to_s
        value = hex_to_bytes(value)
      end

      return_value = "0x" + Digest::SHA3.hexdigest(value, 256)

      if return_value == SHA3_NULL_S
        nil
      else
        return_value
      end
    end

    def hex_to_bytes(hex)
      hex = hex.to_s(16)
      raise "Given value #{hex} is not a valid hex string" unless is_hex_strict(hex)
      hex_value = hex.sub(/^0x/i, '')
      (0...hex_value.size).step(2).map {|c| hex_value[c, 2].to_i(16) }
    end

    def is_hex_strict(hex)
      (hex.is_a?(String) || hex.is_a?(Numeric)) && /^(-)?0x[0-9a-f]*$/i =~ hex
    end
  end


end
