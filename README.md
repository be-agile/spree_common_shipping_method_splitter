# Spree Common Shipping Method Splitter

A Spree extension that keeps items of different shipping categories in a single shipment
as long as the categories have at least one shipping method in common.

## Why

Spree's default stock splitter `Spree::Stock::Splitter::ShippingCategory` always puts items of
different shipping categories into separate shipments. That is the right behaviour for categories
that cannot travel together (refrigerated / frozen / hazardous), but it also splits carts whose
categories merely *differ in the methods they accept*, and the customer ends up paying shipping twice.

A typical example is a small, light product that can be sent either by parcel or by a cheap
mail service, while every other product can only be sent by parcel:

| Shipping category | Shipping methods |
| --- | --- |
| Parcel only | Parcel |
| Parcel or mail | Parcel, Mail |

With the default splitter, a cart containing one product of each category becomes two shipments
(Parcel + Mail). With this extension the cart stays in one shipment, and Spree's existing
`Spree::Stock::Package#shipping_methods` (the intersection of the shipping methods of all categories
in the package) offers only Parcel.

Categories that share no shipping method are still split into separate shipments exactly as before:

| Shipping category | Shipping methods |
| --- | --- |
| Refrigerated | Refrigerated delivery |
| Frozen | Frozen delivery |
| Either | Refrigerated delivery, Frozen delivery |

* Refrigerated + Either → one shipment, Refrigerated delivery only
* Refrigerated + Frozen → two shipments (no common method)
* Refrigerated + Frozen + Either → three shipments (no method common to *all* categories; packages are never
  merged partially)

No configuration is required: the decision is made from the shipping method data of the store.

## Installation

1. Add this extension to your Gemfile:

    ```ruby
    gem 'spree_common_shipping_method_splitter', github: 'be-agile/spree_common_shipping_method_splitter'
    ```

2. Then bundle install:

    ```bash
    bundle install
    ```

The extension replaces `Spree::Stock::Splitter::ShippingCategory` in `Spree.stock_splitters` with
`Spree::Stock::Splitter::CommonShippingMethod` at the same position, so the order of the
remaining splitters (`Backordered`, `Digital`) is unchanged.

## License

This extension is available as open source under the terms of either:
* [GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later)](https://www.gnu.org/licenses/agpl-3.0.en.html)
* [BSD 3-Clause License](https://opensource.org/licenses/BSD-3-Clause)

## Credits

[be agile Co., Ltd.](https://be-agile.jp/)
