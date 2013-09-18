  def parse_key(key)
    if key =~ /\[/
      keys_array = key.match(/(?<head>\w+)\[(?<second>\w+)\](?<rest>.*)/)
      [keys_array["head"]] + parse_key(keys_array["second"]+keys_array["rest"])
    else
      [key]
    end
  end


input = "cat[name][dog]"
p parse_key(input)
