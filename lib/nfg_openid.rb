require "nfg_openid/engine"
require "nfg_openid/middleware"
require "omniauth/openid_connect"

module NfgOpenid
  class Configuration
    class << self
      def auth_path
        "/admin/auth"
      end

      def provider_name
        "nfg-openid"
      end

      def auth_path_with_provider
        "#{self.auth_path}/#{self.provider_name}"
      end

      def callback_path
        "#{self.auth_path_with_provider}/callback"
      end

      def setup_path
        "#{self.auth_path_with_provider}/setup"
      end

      def openid_options
        {
          client_options: {
            port: 443,
            scheme: "https",
            host: APP_CONFIG[:nfg_openid][:host],
            identifier: APP_CONFIG[:nfg_openid][:client_id],
            secret: APP_CONFIG[:nfg_openid][:client_secret],
          },
          callback_path: self.callback_path,
          request_path: self.auth_path_with_provider,
          setup_path: self.setup_path,
          name: self.provider_name,
          discovery: true,
          issuer: APP_CONFIG[:nfg_openid][:discovery_endpoint],
          setup: true,
          scope: [:openid, :email, :profile, :address],
        }
      end
    end
  end
end
