
def parse_structure(file_path)
  content = File.read(file_path)
  methods = []
  properties = []
  
  # Match instance methods: name followed by types and imp
  content.scan(/name\s+0x[0-9a-f]+\s+(?:-[\[\w\s:]+\]|[\w:]+)\n\s+types\s+0x[0-9a-f]+\s+(.+)\n\s+imp\s+0x[0-9a-f]+\s+\(0x[0-9a-f]+\)\s+(.+)/) do |types, method_name|
    methods << { name: method_name, types: types }
  end

  # Match properties
  content.scan(/name\s+0x[0-9a-f]+\s+(\w+)\n\s+attributes\s+0x[0-9a-f]+\s+(.+)/) do |prop_name, attributes|
    properties << { name: prop_name, attr: attributes }
  end

  { methods: methods.uniq, properties: properties.uniq }
end

['ImageBase', 'VariantBase', 'CollectionBase', 'SessionBase'].each do |base|
  file = "reconstructed_codebase/Headers/Frameworks/AppCoreShared/#{base}_Structure.txt"
  next unless File.exist?(file)
  res = parse_structure(file)
  puts "--- #{base} ---"
  puts "Properties:"
  res[:properties].each { |p| puts "  #{p[:name]} (#{p[:attr]})" }
  puts "Methods (First 10):"
  res[:methods].first(10).each { |m| puts "  #{m[:name]} -> #{m[:types]}" }
  puts "\n"
end
