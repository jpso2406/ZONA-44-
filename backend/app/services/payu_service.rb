class PayuService
  include HTTParty
  
  # Configuración de PayU (para simulación)
  BASE_URL = 'https://sandbox.api.payulatam.com' # URL de sandbox para pruebas
  API_LOGIN = 'pRRXKOl8ikMmt9u' # Credenciales de sandbox
  API_KEY = '4Vj8eK4rloUd272L48hsrarnUA' # API Key de sandbox
  
  def initialize(order)
    @order = order
    @merchant_id = '508029' # Merchant ID de sandbox
  end
  
  # Generar datos de pago para PayU
  def generate_payment_data
    {
      merchant: {
        apiLogin: API_LOGIN,
        apiKey: API_KEY
      },
      transaction: {
        order: {
          accountId: @merchant_id,
          referenceCode: @order.order_number,
          description: "Pedido #{@order.order_number} - Pizzeria",
          language: "es",
          signature: generate_signature,
          additionalValues: {
            TX_VALUE: {
              value: @order.total_amount,
              currency: "COP"
            }
          },
          buyer: {
            merchantBuyerId: "1",
            fullName: @order.customer_name,
            emailAddress: @order.customer_name,
            contactPhone: @order.customer_phone,
            dniNumber: "12345678"
          },
          shippingAddress: {
            street1: "Calle 123",
            street2: "Apto 456",
            city: "Bogotá",
            state: "Cundinamarca",
            country: "CO",
            postalCode: "110111"
          }
        },
        payer: {
          merchantPayerId: "1",
          fullName: @order.customer_name,
          emailAddress: @order.customer_name,
          contactPhone: @order.customer_phone,
          dniNumber: "12345678"
        },
        extraParameters: {
          INSTALLMENTS_NUMBER: 1
        },
        additionalValues: {
          TX_VALUE: {
            value: @order.total_amount,
            currency: "COP"
          }
        }
      }
    }
  end
  
  # Simular proceso de pago (sin hacer llamada real a PayU)
  def simulate_payment(payment_method)
    # Simular diferentes escenarios de pago
    case payment_method
    when 'credit_card'
      simulate_credit_card_payment
    when 'debit_card'
      simulate_debit_card_payment
    when 'pse'
      simulate_pse_payment
    when 'cash'
      simulate_cash_payment
    else
      { success: false, error: 'Método de pago no válido' }
    end
  end
  
  # Simular pago con tarjeta de crédito
  def simulate_credit_card_payment
    # Simular 90% de éxito en pagos con tarjeta
    if rand < 0.9
      transaction_id = "TXN-#{SecureRandom.hex(8).upcase}"
      response = {
        success: true,
        transaction_id: transaction_id,
        status: "APPROVED",
        message: "Pago aprobado exitosamente",
        payment_method: "credit_card",
        amount: @order.total_amount,
        currency: "COP",
        timestamp: Time.current.iso8601
      }
      
      # Marcar orden como pagada
      @order.mark_as_paid!(transaction_id, response.to_json)
      
      response
    else
      response = {
        success: false,
        error: "Pago rechazado - Fondos insuficientes",
        payment_method: "credit_card",
        timestamp: Time.current.iso8601
      }
      
      # Marcar orden como fallida
      @order.mark_as_failed!(response.to_json)
      
      response
    end
  end
  
  # Simular pago con tarjeta de débito
  def simulate_debit_card_payment
    if rand < 0.95
      transaction_id = "TXN-#{SecureRandom.hex(8).upcase}"
      response = {
        success: true,
        transaction_id: transaction_id,
        status: "APPROVED",
        message: "Pago aprobado exitosamente",
        payment_method: "debit_card",
        amount: @order.total_amount,
        currency: "COP",
        timestamp: Time.current.iso8601
      }
      
      @order.mark_as_paid!(transaction_id, response.to_json)
      response
    else
      response = {
        success: false,
        error: "Pago rechazado - Tarjeta bloqueada",
        payment_method: "debit_card",
        timestamp: Time.current.iso8601
      }
      
      @order.mark_as_failed!(response.to_json)
      response
    end
  end
  
  # Simular pago PSE
  def simulate_pse_payment
    if rand < 0.98
      transaction_id = "TXN-#{SecureRandom.hex(8).upcase}"
      response = {
        success: true,
        transaction_id: transaction_id,
        status: "APPROVED",
        message: "Transferencia PSE exitosa",
        payment_method: "pse",
        amount: @order.total_amount,
        currency: "COP",
        timestamp: Time.current.iso8601
      }
      
      @order.mark_as_paid!(transaction_id, response.to_json)
      response
    else
      response = {
        success: false,
        error: "Transferencia PSE fallida - Banco no disponible",
        payment_method: "pse",
        timestamp: Time.current.iso8601
      }
      
      @order.mark_as_failed!(response.to_json)
      response
    end
  end
  
  # Simular pago en efectivo
  def simulate_cash_payment
    # Pago en efectivo siempre es exitoso (se confirma al recibir el dinero)
    transaction_id = "CASH-#{SecureRandom.hex(8).upcase}"
    response = {
      success: true,
      transaction_id: transaction_id,
      status: "PENDING_CONFIRMATION",
      message: "Pago en efectivo - Pendiente de confirmación",
      payment_method: "cash",
      amount: @order.total_amount,
        currency: "COP",
      timestamp: Time.current.iso8601,
      note: "El pago se confirmará cuando se reciba el dinero en efectivo"
    }
    
    # Para pagos en efectivo, mantenemos el estado como pending hasta confirmación
    @order.update!(
      payu_transaction_id: transaction_id,
      payu_response: response.to_json
    )
    
    response
  end
  
  # Generar firma para PayU
  def generate_signature
    # En producción, esta sería la firma real de PayU
    # Para simulación, generamos una firma dummy
    Digest::MD5.hexdigest("#{API_KEY}~#{@merchant_id}~#{@order.order_number}~#{@order.total_amount}~COP")
  end
  
  # Obtener URL de pago (para integración real)
  def payment_url
    "#{BASE_URL}/payments-api/4.0/service.cgi"
  end
  
  # Verificar estado de transacción (para integración real)
  def check_transaction_status(transaction_id)
    # En producción, haríamos una llamada real a PayU
    # Para simulación, retornamos un estado aleatorio
    {
      transaction_id: transaction_id,
      status: ["APPROVED", "PENDING", "DECLINED"].sample,
      timestamp: Time.current.iso8601
    }
  end
end
