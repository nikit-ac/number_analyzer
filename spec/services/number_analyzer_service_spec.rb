# frozen_string_literal: true

require './app/services/numbers_analyzer_service'
require 'rails_helper'

RSpec.describe NumbersAnalyzerService, type: :service do
  let(:even_size_arr) { [25, 26, 15, 16, 22, 12, 12, 16, 10, 22, 22, 12] }
  let(:arr) { [-81, 40, 35, 25.5, 40, 150, 15, 60, 25, 10, 100, 22, 13.5] }
  subject { NumbersAnalyzerService.new(arr).perform }

  describe '#perform' do
    it 'should returns the minimum value from an array' do
      expect(subject[:minimum]).to eq(-81)
    end

    it 'should returns the average value from an array' do
      expect(subject[:average]).to eq(35)
    end

    context 'if array have odd size' do
      it 'should returns the median value from an array' do
        expect(subject[:median]).to eq(25.5)
      end
    end

    context 'if array have even size' do
      let(:arr) { even_size_arr }

      it 'should returns the median value from an array' do
        expect(subject[:median]).to eq(16)
      end
    end

    context 'if array have outliers' do
      it 'should returns the outliers from an array' do
        expect(subject[:outlier]).to match_array([150, -81, 100])
      end
    end

    context "if array haven't outliers" do
      let(:arr) { even_size_arr }

      it 'should returns the outliers from an array' do
        expect(subject[:outlier]).to eq([])
      end
    end
  end
end
