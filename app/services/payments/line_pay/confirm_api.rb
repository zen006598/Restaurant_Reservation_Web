module Payments  
  module LinePay
    class ConfirmApi
      def initialize(transaction_id, amount)
        @transaction_id = transaction_id
        @amount = amount
      end

      def perform
        header
        body
        uri = URI.parse("https://sandbox-api-pay.line.me/v3/payments/#{@transaction_id}/confirm")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(uri.request_uri, @header)
        request.body = @body.to_json
        response = http.request(request)
        return response.body
      end

      private

      def header
        header_nonce
        get_signature
        @header = {"Content-Type": "application/json",
              "X-LINE-ChannelId": ENV["LINE_CHANNELID"],
              "X-LINE-Authorization-Nonce": @nonce,
              "X-LINE-Authorization": @signature }
      end

      def body
        @body = {
          amount: @amount,
          currency: "TWD"
        }
      end

      def header_nonce
        @nonce = SecureRandom.uuid
      end
      
      def get_signature
        body
        header_nonce
        secrect = ENV["LINE_CHANNEL_SECRET_KEY"]
        signature_uri = "/v3/payments/#{@transaction_id}/confirm"
        message = "#{secrect}#{signature_uri}#{@body.to_json}#{@nonce}"
        hash = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secrect, message)
        @signature = Base64.strict_encode64(hash)
      end
    end
  end
end
