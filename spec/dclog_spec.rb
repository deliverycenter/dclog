# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Dclog do
  describe 'Dclog logging' do
    context 'Call logger with correct params' do
      let(:logger) { double('logger') }
      let(:block_caller_message) { 'block (5 levels) in <top (required)>' }

      before do
        allow(Rails).to receive(:logger).and_return(logger)
        allow(logger).to receive(:error)
          .with(block_caller_message).and_return(nil)
      end

      context 'when passing hash' do
        it do
          expect(logger).to receive(:error)
            .with(block_caller_message) { 'Error on validation' }

          Dclog.error('Error on validation')
        end
      end
    end
  end
end
