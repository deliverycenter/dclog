# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Dclog::Formatter do
  describe 'Json Formatter' do
    context 'logging with a string' do
      it do
        time = Time.now

        expect(subject.call('error', time, nil, 'Error x')).to eq({
          severity: 'error',
          date: time.strftime('%Y-%m-%d %H:%M:%S'),
          caller: nil,
          request_id: nil,
          message: 'Error x'
        }.to_json + "\n")
      end
    end

    # not supported yet
    xcontext 'logging with more keys' do
      it do
        time = Time.now

        expect(subject.call('error', time, nil,
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
end
