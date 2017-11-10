class TransactionsController < ApplicationController
  def index
    @transactions = FraudTransaction.order(time: :desc)
  end

  def detect_fraud
    transaction = FraudTransaction.find transacion_params[:id]
    @fraud_response = transaction.detect_fraud
    @fraud_response['id'] = transaction.id
    respond_to { |format| format.json { render json: @fraud_response.to_json } }
  end
  
  private 
  def transacion_params
    params.require(:fraud_transaction).permit(:id)
  end
  
end
