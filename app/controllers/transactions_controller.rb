class TransactionsController < ApplicationController
  def index
    @transactions = FraudTransaction.all
  end

  def detect_fraud
  end
end
