
metadata = File.read('/tmp/appcore_metadata.txt')
classes = {}
current_class = nil

metadata.each_line do |line|
  if line =~ /^[0-9a-f]+ (0x[0-9a-f]+)/
    addr = $1
    current_class = { addr: addr }
    classes[addr] = current_class
  elsif line =~ /name\s+0x[0-9a-f]+\s+(.+)$/
    name = $1.strip
    # Skip relative address markers if present
    name = name.split(' ').last if name =~ /^\(0x/
    current_class[:name] = name if current_class
  elsif line =~ /superclass\s+(0x[0-9a-f]+)\s+(.+)$/
    if current_class
      s_addr = $1
      s_name = $2.strip
      s_name = s_name.split(' ').last if s_name =~ /^\(0x/
      current_class[:superclass_addr] = s_addr
      current_class[:superclass_name] = s_name
    end
  end
end

classes.values.each do |c|
  next unless c[:name]
  puts "#{c[:name]} : #{c[:superclass_name] || 'Unknown'} (#{c[:superclass_addr] || 'None'})"
end
