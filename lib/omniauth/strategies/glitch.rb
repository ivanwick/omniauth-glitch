require 'omniauth-oauth2'

## part of default stack
# require 'multi_json'

module OmniAuth
  module Strategies
    class Glitch < OmniAuth::Strategies::OAuth2
      option :client_options, {
          :site => 'https://api.glitch.com',
          :authorize_url => '/oauth2/authorize',
          :token_url => '/oauth2/token'
        }
        
      option :authorize_params, {
          :scope => 'identity',  # default if not specified in OmniAuth::Builder (initializer)
          :response_type => 'code'
        }

      uid { user_data['player_tsid'] }
      
      info do
        {
          'user_name' => user_data['user_name'],
          'player_name' => user_data['player_name'],
          'avatar_url' => user_data['avatar_url'],
        }
      end

      def user_data
        unless @data
          access_token.options.merge!({:param_name => 'oauth_token', :mode => :query})
          response = access_token.post('/simple/players.info')
          @data = MultiJson.decode(response.body)
        end

        @data
      end

    end
  end
end
