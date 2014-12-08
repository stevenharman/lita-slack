require 'faraday'

require 'lita/adapters/slack/rtm_start_response'
require 'lita/adapters/slack/im_open_response'

module Lita
  module Adapters
    class Slack < Adapter
      class API
        def initialize(token)
          @token = token
        end

        def im_open
          response_data = call_api("im.open")

          IMOpenResponse.build(response_data)
        end

        def rtm_start
          response_data = call_api("rtm.start")

          RTMStartResponse.build(response_data)
        end

        private

        attr_reader :token

        def call_api(method, post_data = {})
          response = Faraday.post(
            'https://slack.com/api/rtm.start',
            { token: token }.merge(post_data)
          )

          unless response.success?
            raise "Slack API call to #{method} failed with status code #{response.status}"
          end

          MultiJson.load(response.body)
        end
      end
    end
  end
end