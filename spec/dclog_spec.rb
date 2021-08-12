# frozen_string_literal: true

RSpec.describe Dclog do
  xdescribe 'Json Formatter' do
    let(:log) { Dclog::Formatters::Json.new }

    context 'logging with a string' do
      it do
        time = Time.now

        expect(log.call('error', time, nil, 'Error x')).to eq({
          severity: 'error',
          time: time,
          message: 'Error x'
        }.to_json + "\r\n")
      end
    end

    context 'logging with more keys' do
      it do
        time = Time.now

        expect(log.call('error', time, nil,
                        { message: 'Error', class: 'ActiveRecord', error: 'ActiveRecord::Validation::Error' }))
          .to eq({
            severity: 'error',
            time: time,
            message: {
              message: 'Error',
              class: 'ActiveRecord',
              error: 'ActiveRecord::Validation::Error'
            }
          }.to_json + "\r\n")
      end
    end
  end

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
