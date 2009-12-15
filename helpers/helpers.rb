def stylesheets(*sheets)
  sheets.each { |sheet|
    haml_tag(:link, :href => "/#{sheet}.css", :type => "text/css", :rel => "stylesheet")
  }
end