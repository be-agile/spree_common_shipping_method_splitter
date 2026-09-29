module Spree
  module Stock
    module Splitter
      # 配送カテゴリが違っても、全カテゴリ共通の配送方法があれば同梱する。
      # 共通の配送方法が無い場合だけ Spree 標準どおりカテゴリごとに出荷を分ける
      # (3 カテゴリ以上で一部同士にだけ共通の配送方法がある場合も、部分的な同梱はせず全カテゴリで分ける)。
      # 同梱した出荷の配送方法候補は Spree::Stock::Package#shipping_methods(全カテゴリの積集合)で絞られる。
      class CommonShippingMethod < ShippingCategory
        def split(packages)
          split_packages = packages.flat_map do |package|
            package.shipping_methods.empty? ? split_by_category(package) : [ package ]
          end
          return_next(split_packages)
        end
      end
    end
  end
end
