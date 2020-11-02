class OperatingCostController < ApplicationController
  def new  
  end

  def create
    invoice = params[:invoice]
    operation_cost = generate_operating_cost(invoice)
    @process_calculation =  get_process_calculation(operation_cost, invoice)
  end

  private 
  def generate_operating_cost(invoice)
    url = "https://chita.cl/api/v1/pricing/simple_quote"
    query = {
      :client_dni => invoice["client_dni"],
      :debtor_dni => invoice["debtor_dni"],
      :document_amount => invoice["document_amount"],
      :folio => invoice["folio"],
      :expiration_date => invoice["expiration_date"]
    }
    headers = {
      "X-APi-key" => "UVG5jbLZxqVtsXX4nCJYKwtt"
    }

    HTTParty.get(url, :headers => headers, :query => query)
  end

  def get_process_calculation(operation_cost, invoice)
    # Invoice variables # 
    expiration_date = invoice["expiration_date"] # y
    document_amount = invoice["document_amount"].to_f # z

    # Operation cost variables  #
    document_rate = operation_cost["document_rate"] # a
    commission = operation_cost["commission"] # b
    advance_percent = (operation_cost["advance_percent"] / 100).to_f # c


    # Calculated variables #
    days_term = (Date.strptime(expiration_date, '%Y-%m-%d') - Date.today + 1 ).to_i # d


    financing_cost = (document_amount * advance_percent) * (document_rate / 30 * days_term) # e
    giro_to_receive = (document_amount * advance_percent) * (financing_cost + commission)
    excess = document_amount -  (document_amount * advance_percent)

    return {
      "financing_cost" => financing_cost.to_d.round(2, :truncate).to_f,
      "giro_to_receive" => giro_to_receive.to_d.round(2, :truncate).to_f,
      "excess" => excess.to_d.round(2, :truncate).to_f
    }

  end
  
end