require "net/http"
require "uri"
require "json"
require "digest"
require "securerandom"

class PayuService
  PAYU_API_URL = "https://sandbox.api.payulatam.com/payments-api/4.0/service.cgi"

  def initialize(order, card_data = {})
    @order = order
    @card_data = card_data
  end

  # Genera la firma MD5 requerida por PayU
  def generate_signature
    api_key = ENV["PAYU_API_KEY"]
    merchant_id = ENV["PAYU_MERCHANT_ID"]
    reference_code = @order.reference
    amount = sprintf("%.1f", @order.total_amount.to_f)
    currency = "COP"
    signature_string = [ api_key, merchant_id, reference_code, amount, currency ].join("~")
    Digest::MD5.hexdigest(signature_string)
  end

  def create_payment(payment_method)
    card_number = @card_data[:number].to_s
    payment_method_api = detect_card_type(card_number, payment_method)
    expiration_date = format_expiration_date(@card_data[:expiration])

    transaction_hash = {
      "order" => {
        "accountId" => ENV["PAYU_ACCOUNT_ID"],
        "referenceCode" => @order.reference,
        "description" => "Pago pedido #{@order.order_number}",
        "language" => "es",
        "signature" => generate_signature,
        "notifyUrl" => "https://tusitio.com/notify_payu",
        "additionalValues" => {
          "TX_VALUE" => {
            "value" => @order.total_amount.to_f,
            "currency" => "COP"
          }
        }
      },
      "type" => "AUTHORIZATION_AND_CAPTURE",
      "paymentMethod" => payment_method_api,
      "paymentCountry" => "CO",
      "ipAddress" => "127.0.0.1",
      "payer" => {
        "merchantPayerId" => "1",
        "fullName" => @order.customer_name,
        "emailAddress" => @order.customer_email,
        "contactPhone" => @order.customer_phone,
        "dniNumber" => "12345678"
      },
      "extraParameters" => {
        "INSTALLMENTS_NUMBER" => 1
      }
    }

    if %w[VISA MASTERCARD AMEX DINERS].include?(payment_method_api)
      transaction_hash["creditCard"] = {
        "number" => @card_data[:number],
        "expirationDate" => expiration_date,
        "securityCode" => @card_data[:cvv],
        "name" => @card_data[:name]
      }
    end

    payload = {
      "language" => "es",
      "command" => "SUBMIT_TRANSACTION",
      "merchant" => {
        "apiKey" => ENV["PAYU_API_KEY"],
        "apiLogin" => ENV["PAYU_API_LOGIN"]
      },
      "transaction" => transaction_hash,
      "test" => true # Forzamos sandbox
    }

    # === DEBUG: Ver JSON de envío ===
    puts "=== PAYU SANDBOX REQUEST ==="
    puts JSON.pretty_generate(payload)
    puts "============================"

    uri = URI.parse(PAYU_API_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri, {
      "Content-Type" => "application/json",
      "Accept" => "application/json"
    })
    request.body = payload.to_json

    response = http.request(request)

    # Forzar UTF-8 en la respuesta para evitar errores de codificación
    raw_body = response.body.force_encoding("UTF-8")

    # === DEBUG: Ver respuesta formateada ===
    puts "=== PAYU SANDBOX RESPONSE ==="
    puts "HTTP #{response.code}"
    begin
      parsed_json = JSON.parse(raw_body)
      puts JSON.pretty_generate(parsed_json)
    rescue JSON::ParserError
      puts raw_body # Si no es JSON válido, mostrar tal cual
    end
    puts "============================"

    JSON.parse(raw_body)
  end

  private

  def detect_card_type(number, default_method)
    case number[0]
    when "4" then "VISA"
    when "5" then "MASTERCARD"
    when "3" then "AMEX"
    when "6" then "DINERS"
    else default_method
    end
  end

  def format_expiration_date(exp)
    if exp.match(%r{\d{2}/\d{2,4}})
      mm, yy = exp.split("/")
      yy = yy.length == 2 ? "20#{yy}" : yy
      "#{yy}/#{mm}"
    else
      exp
    end
  end
end
