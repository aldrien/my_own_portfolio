PDFKit.configure do |config|
  config.default_options = {
    :page_size     => 'Letter',
    :margin_top    => '0.5in',
    :margin_right  => '0.5in',
    :margin_bottom => '0.7in',
    :margin_left   => '0.5in'
  }
end