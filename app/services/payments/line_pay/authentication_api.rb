module Payments  
  module LinePay
    class AuthenticationApi
      def initialize(reservation_id, capitation, quantity)
        @reservation_id = reservation_id
        @capitation = capitation
        @quantity = quantity
      end

      def perform
        body
        header
        amount
        uri = URI.parse("https://sandbox-api-pay.line.me/v3/payments/request")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(uri.request_uri, @header)
        request.body = @body.to_json
        response = http.request(request)
        
        response = JSON.parse(response.body)
        return_code = response['returnCode']

        if return_code = '0000'
          return response['info']['paymentUrl']['web']
        end
      end

      private
      
      def packages_id
        "package#{SecureRandom.uuid}"
      end
      
      def amount
        @capitation * @quantity
      end
      
      def body
        @body = 
          { amount: amount,
            currency: "TWD",
            orderId: @reservation_id,
            packages: [{ 
              id: packages_id,
              amount: amount,
              products: [ {
                name: 'WoDing',
                quantity: @quantity,
                price: @capitation } ] 
            }],
            redirectUrls: { 
              confirmUrl: "http://127.0.0.1:3000/reservations/#{@reservation_id}/confirm_url",
              cancelUrl: "http://127.0.0.1:3000/reservations/#{@reservation_id}/cancel_url" 
              }
          }
      end

      def header
        header_nonce
        get_signature
        @header = {"Content-Type": "application/json",
                  "X-LINE-ChannelId": ENV["LINE_CHANNELID"],
                  "X-LINE-Authorization-Nonce": @nonce,
                  "X-LINE-Authorization": @signature }
      end

      def header_nonce
        @nonce = SecureRandom.uuid
      end
      
      def get_signature
        body
        header_nonce
        secrect = ENV["LINE_CHANNEL_SECRET_KEY"]
        signature_uri = "/v3/payments/request"
        message = "#{secrect}#{signature_uri}#{@body.to_json}#{@nonce}"
        hash = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secrect, message)
        @signature = Base64.strict_encode64(hash)
      end
    end
  end
end
