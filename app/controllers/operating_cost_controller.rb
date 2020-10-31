class OperatingCostController < ApplicationController
  def new  
  end

  def create
    invoice = params[:invoice]
    @operation_cost = generate_operating_cost(invoice)
  end

  private 
  def generate_operating_cost(invoice)
    url = "https://chita.cl/api/v1/pricing/simple_quote"
    query = {
      "client_dni" => invoice["client_dni"],
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
  
end