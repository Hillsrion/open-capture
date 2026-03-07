
def parse_structure(file_path)
  content = File.read(file_path)
  methods = []
  properties = []
  
  # Match instance methods: name followed by types and imp
  content.scan(/name\s+0x[0-9a-f]+\s+(.+)\n\s+types\s+0x[0-9a-f]+\s+(.+)\n\s+imp\s+0x[0-9a-f]+\s+\(0x[0-9a-f]+\)\s+(.+)/) do |name, types, method_name|
    methods << { name: name, types: types, full_name: method_name }
  end

  # Match properties
  content.scan(/name\s+0x[0-9a-f]+\s+(\w+)\n\s+attributes\s+0x[0-9a-f]+\s+(.+)/) do |prop_name, attributes|
    properties << { name: prop_name, attr: attributes }
  end

  { methods: methods.uniq, properties: properties.uniq }
end

['CullingWindowController', 'HistogramInspectorTool'].each do |ctrl|
  file = "reconstructed_codebase/Headers/Main/#{ctrl}_Structure.txt"
  next unless File.exist?(file)
  res = parse_structure(file)
  puts "--- #{ctrl} ---"
  puts "Properties:"
  res[:properties].each { |p| puts "  #{p[:name]} (#{p[:attr]})" }
  puts "Methods (First 20):"
  res[:methods].first(20).each { |m| puts "  #{m[:name]} -> #{m[:types]}" }
  puts "\n"
end
