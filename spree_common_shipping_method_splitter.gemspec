# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_common_shipping_method_splitter/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_common_shipping_method_splitter'
  s.version     = SpreeCommonShippingMethodSplitter::VERSION
  s.summary     = 'Keep items of different shipping categories in one shipment when they share a shipping method'
  s.description = 'Replaces the Spree::Stock::Splitter::ShippingCategory stock splitter so that packages are ' \
                  'split by shipping category only when the categories have no shipping method in common'
  s.required_ruby_version = '>= 3.1.4'

  s.author      = 'be agile Co., Ltd.'
  s.email       = 'develop@be-agile.jp'
  s.homepage    = 'https://github.com/be-agile/spree_common_shipping_method_splitter'
  s.licenses    = ['AGPL-3.0-or-later']

  s.files        = Dir['LICENSE', 'README.md', 'app/**/*', 'lib/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree', '= 5.3.6'
  s.add_dependency 'spree_extension'

  s.add_development_dependency 'spree_dev_tools'
end
