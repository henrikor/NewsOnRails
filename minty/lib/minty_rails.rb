# -*- encoding : utf-8 -*-
module MintyRails # :nodoc:
  module MintCode
    def mint_code(request = nil)
      return unless Mint.enabled?
      Mint.new.mint_code(request)
    end
    
    # An after_filter to automatically add the mint code.
    def add_mint_code
      code = mint_code(request)
      return if code.blank? || (response.body.is_a? Proc)
      response.body.gsub! '</head>', code + '</head>'
    end
  end

  class Mint
    # The path where Mint is installed
    @@mint_path = '/mint'
    cattr_accessor :mint_path

    # The environments in which to enable the Mint code.  Defaults
    # to 'production' only.
    @@environments = ['production']
    cattr_accessor :environments

    # Return true if Minty Rails is enabled and configured correctly.
    def self.enabled?
      (environments.include?(RAILS_ENV) and
        not mint_path.blank?)
    end
    
    def mint_code(request = nil)
      code = <<-HTML
      <script src="#{mint_path}/?js" type="text/javascript"></script>
      HTML
      code
    end
  end
end
