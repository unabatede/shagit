def stylesheets(*sheets)
  sheets.each { |sheet|
    haml_tag(:link, :href => "/#{sheet}.css", :type => "text/css", :rel => "stylesheet")
  }
end

def cycle(*values)
  @cycles ||= {}
  @cycles[values] ||= -1 # first value returned is 0
  next_value = @cycles[values] = (@cycles[values] + 1) % values.size
  values[next_value]
end

def full_path
  hostname = `hostname`
  full_path = `pwd`
  "#{reformat_string(hostname)}:#{reformat_string(full_path)}"
end

def reformat_string(source)
  source.chomp
end