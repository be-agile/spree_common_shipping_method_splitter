module SpreeCommonShippingMethodSplitter
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_common_shipping_method_splitter'

    # Spree 標準の ShippingCategory splitter と同じ位置(Backordered・Digital より前)に入れ替える。
    # `Spree.stock_splitters` の既定値は spree_core の engine が after_initialize で設定し、
    # `Spree::Stock::Splitter::*` は autoload 対象なので、initializer 直下ではなく after_initialize で行う。
    config.after_initialize do
      Spree.stock_splitters.map! do |splitter|
        if splitter == Spree::Stock::Splitter::ShippingCategory
          Spree::Stock::Splitter::CommonShippingMethod
        else
          splitter
        end
      end
    end
  end
end
