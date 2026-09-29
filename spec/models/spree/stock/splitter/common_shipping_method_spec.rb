# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Spree::Stock::Splitter::CommonShippingMethod, type: :model do
  describe 'Spree.stock_splitters' do
    subject { Spree.stock_splitters }

    it { is_expected.to eq [ described_class, Spree::Stock::Splitter::Backordered, Spree::Stock::Splitter::Digital ] }
  end

  describe '#split' do
    # 配送カテゴリ A, B, C と配送方法 X (A+B), Y (B のみ), Z (C のみ)。
    # A と B は X を共有し、A と C には共通の配送方法が無い。
    let!(:store) { Spree::Store.default.persisted? ? Spree::Store.default : create(:store) }
    let!(:stock_location) { Spree::StockLocation.first || create(:stock_location, propagate_all_variants: false) }
    let(:category_a) { create(:shipping_category, name: 'A') }
    let(:category_b) { create(:shipping_category, name: 'B') }
    let(:category_c) { create(:shipping_category, name: 'C') }
    let!(:method_x) { create(:shipping_method, name: 'X', shipping_categories: [ category_a, category_b ]) }
    let!(:method_y) { create(:shipping_method, name: 'Y', shipping_categories: [ category_b ]) }
    let!(:method_z) { create(:shipping_method, name: 'Z', shipping_categories: [ category_c ]) }
    let(:product_a) { create(:product, shipping_category: category_a) }
    let(:product_b) { create(:product, shipping_category: category_b) }
    let(:product_c) { create(:product, shipping_category: category_c) }
    let(:order) { create(:order, state: 'cart', completed_at: nil) }

    subject(:packages) { Spree::Stock::Coordinator.new(order).build_packages }

    before do
      products.each do |product|
        stock_location.stock_items.find_or_create_by!(variant: product.master).update!(count_on_hand: 10)
        create(:line_item, order: order, variant: product.master)
      end
      order.line_items.reload
    end

    context 'A のみ' do
      let(:products) { [ product_a ] }

      its(:size) { is_expected.to eq 1 }
      it { expect(packages.first.shipping_methods).to contain_exactly(method_x) }
    end

    context 'B のみ' do
      let(:products) { [ product_b ] }

      its(:size) { is_expected.to eq 1 }
      it { expect(packages.first.shipping_methods).to contain_exactly(method_x, method_y) }
    end

    context 'A + B (共通の配送方法あり)' do
      let(:products) { [ product_a, product_b ] }

      its(:size) { is_expected.to eq 1 }
      it { expect(packages.first.shipping_methods).to contain_exactly(method_x) }
    end

    context 'A + C (共通の配送方法なし)' do
      let(:products) { [ product_a, product_c ] }

      its(:size) { is_expected.to eq 2 }
      it { expect(packages.map(&:shipping_methods)).to contain_exactly([ method_x ], [ method_z ]) }
    end
  end
end
