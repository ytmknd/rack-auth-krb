require 'goliath'
require 'basic_and_nego/request'
require 'basic_and_nego/logic'

module Goliath
  module Rack
    module Auth
      module Krb
        class BasicAndNego
          include Goliath::Rack::AsyncMiddleware

          attr_reader :realm, :keytab, :service

          def initialize(app, realm, keytab, service=nil)
            @app = app
            @realm = realm
            @keytab = keytab
            @service = service
          end

          def call(env)
            a = ::BasicAndNego::Logic.new(env, env.logger, realm, keytab, service)
            a.process_request

            return a.response if a.response

            super(env, a.headers)
          end

          def post_process(env, status, headers, body, additional_headers)
            [status, headers.merge(additional_headers), body]
          end

        end
      end
    end
  end
end
