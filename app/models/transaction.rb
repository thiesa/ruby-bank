class Transaction < ApplicationRecord
  TRANSACTION_FEE = 0.0001 ## 0.01%

  validates_inclusion_of :status, in: %w(approved rejected pending)

  monetize :fee_amount_cents,         allow_nil: true
  monetize :transaction_amount_cents, allow_nil: true

  # PAIN transactions are as follows
  # Payments initiation:
  # 1 - CustomerCreditTransferInitiationV06
  # 2 - CustomerPaymentStatusReportV06
  # 7 - CustomerPaymentReversalV05
  # 8 - CustomerDirectDebitInitiationV05

  # Payments mandates:
  # 9  - MandateInitiationRequestV04
  # 10 - MandateAmendmentRequestV04
  # 11 - MandateCancellationRequestV04
  # 12 - MandateAcceptanceReportV04

  # Custom payments:
  # 1000 - CustomerDepositInitiation (@FIXME Will need to implement this properly, for now we use it to demonstrate functionality)
  # 1001 - ListTransactions

  def process_pain *data
    # TODO: Refactor me!

    # Format of PAIN transaction:
    # There must be at least 3 elements
    # transactions.ProcessPAIN([]string{token, "pain", "1", senderDetails, recipientDetails, amount, lat, lon, desc})
    if data.size < 3
      self.errors.add(:base, "payments.ProcessPAIN: Not all data is present. Less than three datum passed.")
      return self.errors.full_messages
    else
      if data[2].present?
        @pain_type = data[2].to_i # go to case statement
        if @pain_type == 0
          self.errors.add(:base, "payments.ProcessPAIN: PAIN type: #{@pain_type} is not a valid.")
          return self.errors.full_messages
        end
      else
        self.errors.add(:base, "payments.ProcessPAIN: Could not get type of PAIN transaction.")
        return self.errors.full_messages
      end

      case @pain_type
      when 1
        if data.size < 9 # There must be at least 9 elements
          self.errors.add(:base, "payments.ProcessPAIN: Not all data is present.")
          return self.errors.full_messages
        else
          pain_credit_transfer_initiation(@pain_type, data)
        end
      when 1000
        if data.size < 8 # There must be at least 8 elements. token~pain~type~amount~lat~lon~desc
          self.errors.add(:base, "payments.ProcessPAIN: Not all data is present.")
          return self.errors.full_messages
        else
          customer_deposit_initiation(@pain_type, data)
        end
      when 1001
        if data.size < 5 # There must be at least 5 elements. token~pain~type~page~perpage
          self.errors.add(:base, "payments.ProcessPAIN: Not all data is present.")
          return self.errors.full_messages
        else
          list_transactions(data)
        end
      end
    end
  end

  def pain_credit_transfer_initiation pain_type, data
    # TODO: Validate input
    # TODO: Check if sender valid w/appauth.GetUserFromToken(data[0])
  end

  def customer_deposit_initiation pain_type, data
  end

  def list_transactions data
  end

  # func painCreditTransferInitiation(painType int64, data []string) (result string, err error) {

  #   # Validate input
  #   sender, err := parseAccountHolder(data[3])
  #   if err != nil {
  #     return "", errors.New("payments.painCreditTransferInitiation: " + err.Error())
  #   }
  #   receiver, err := parseAccountHolder(data[4])
  #   if err != nil {
  #     return "", errors.New("payments.painCreditTransferInitiation: " + err.Error())
  #   }

  #   trAmt := strings.TrimRight(data[5], "\x00")
  #   transactionAmountDecimal, err := decimal.NewFromString(trAmt)
  #   if err != nil {
  #     return "", errors.New("payments.painCreditTransferInitiation: Could not convert transaction amount to decimal. " + err.Error())
  #   }

  #   # Check if sender valid
  #   tokenUser, err := appauth.GetUserFromToken(data[0])
  #   if err != nil {
  #     return "", errors.New("payments.painCreditTransferInitiation: " + err.Error())
  #   }
  #   if tokenUser != sender.AccountNumber {
  #     return "", errors.New("payments.painCreditTransferInitiation: Sender not valid")
  #   }

  #   lat, err := strconv.ParseFloat(data[6], 64)
  #   if err != nil {
  #     return "", errors.New("payments.painCreditTransferInitiation: Could not parse coordinates into float")
  #   }
  #   lon, err := strconv.ParseFloat(data[7], 64)
  #   if err != nil {
  #     return "", errors.New("payments.painCreditTransferInitiation: Could not parse coordinates into float")
  #   }
  #   desc := data[8]

  #   geo := *geo.NewPoint(lat, lon)
  #   transaction := PAINTrans{painType, sender, receiver, transactionAmountDecimal, decimal.NewFromFloat(TRANSACTION_FEE), geo, desc, "approved", 0}

  #   # Checks for transaction (avail balance, accounts open, etc)
  #   balanceAvailable, err := checkBalance(transaction.Sender)
  #   if err != nil {
  #     return "", errors.New("payments.painCreditTransferInitiation: " + err.Error())
  #   }
  #   # Comparing decimals results in -1 if <
  #   if balanceAvailable.Cmp(transaction.Amount) == -1 {
  #     return "", errors.New("payments.painCreditTransferInitiation: Insufficient funds available")
  #   }

  #   # Save transaction
  #   result, err = processPAINTransaction(transaction)
  #   if err != nil {
  #     return "", errors.New("payments.painCreditTransferInitiation: " + err.Error())
  #   }

  #   go push.SendNotification(sender.AccountNumber, "💸 Payment sent!", 5, "default")
  #   go push.SendNotification(receiver.AccountNumber, "💸 Payment received!", 5, "default")

  #   return
  # }



  # func processPAINTransaction(transaction PAINTrans) (result string, err error) {
  #   # Test: pain~1~1b2ca241-0373-4610-abad-da7b06c50a7b@~181ac0ae-45cb-461d-b740-15ce33e4612f@~20

  #   # Save in transaction table
  #   err = savePainTransaction(transaction)
  #   if err != nil {
  #     return "", errors.New("payments.processPAINTransaction: " + err.Error())
  #   }

  #   # Amend sender and receiver accounts
  #   # Amend bank's account with fee addition
  #   err = updateAccounts(transaction)
  #   if err != nil {
  #     return "", errors.New("payments.processPAINTransaction: " + err.Error())
  #   }

  #   return
  # }

  # func parseAccountHolder(account string) (accountHolder AccountHolder, err error) {
  #   accountStr := strings.Split(account, "@")

  #   if len(accountStr) < 2 {
  #     return AccountHolder{}, errors.New("payments.parseAccountHolder: Not all details present")
  #   }

  #   accountHolder = AccountHolder{accountStr[0], accountStr[1]}
  #   return
  # }

  # func customerDepositInitiation(painType int64, data []string) (result string, err error) {
  #   # Validate input
  #   # Sender is bank
  #   sender, err := parseAccountHolder("0@0")
  #   if err != nil {
  #     return "", errors.New("payments.CustomerDepositInitiation: " + err.Error())
  #   }

  #   receiver, err := parseAccountHolder(data[3])
  #   if err != nil {
  #     return "", errors.New("payments.CustomerDepositInitiation: " + err.Error())
  #   }

  #   trAmt := strings.TrimRight(data[4], "\x00")
  #   transactionAmountDecimal, err := decimal.NewFromString(trAmt)
  #   if err != nil {
  #     return "", errors.New("payments.customerDepositInitiation: Could not convert transaction amount to decimal. " + err.Error())
  #   }

  #   # Check if sender valid
  #   tokenUser, err := appauth.GetUserFromToken(data[0])
  #   if err != nil {
  #     return "", errors.New("payments.customerDepositInitiation: " + err.Error())
  #   }
  #   if tokenUser != receiver.AccountNumber {
  #     return "", errors.New("payments.customerDepositInitiation: Sender not valid")
  #   }

  #   lat, err := strconv.ParseFloat(data[5], 64)
  #   if err != nil {
  #     return "", errors.New("payments.customerDepositInitiation: Could not parse coordinates into float")
  #   }
  #   lon, err := strconv.ParseFloat(data[6], 64)
  #   if err != nil {
  #     return "", errors.New("payments.customerDepositInitiation: Could not parse coordinates into float")
  #   }
  #   desc := data[7]

  #   # Issue deposit
  #   # @TODO This flow show be fixed. Maybe have banks approve deposits before initiation, or
  #   # immediate approval below a certain amount subject to rate limiting
  #   geo := *geo.NewPoint(lat, lon)
  #   transaction := PAINTrans{painType, sender, receiver, transactionAmountDecimal, decimal.NewFromFloat(TRANSACTION_FEE), geo, desc, "approved", 0}
  #   # Save transaction
  #   result, err = processPAINTransaction(transaction)
  #   if err != nil {
  #     return "", errors.New("payments.CustomerDepositInitiation: " + err.Error())
  #   }

  #   go push.SendNotification(receiver.AccountNumber, "💸 Deposit received!", 5, "default")

  #   return
  # }



  # func listTransactions(data []string) (result []PAINTrans, err error) {
  #   tokenUserAccountNumber, err := appauth.GetUserFromToken(data[0])
  #   if err != nil {
  #     return []PAINTrans{}, errors.New("payments.ListTransactions: " + err.Error())
  #   }

  #   page, err := strconv.Atoi(data[3])
  #   if err != nil {
  #     return []PAINTrans{}, errors.New("payments.ListTransactions: " + err.Error())
  #   }
  #   perPage, err := strconv.Atoi(data[4])
  #   if err != nil {
  #     return []PAINTrans{}, errors.New("payments.ListTransactions: " + err.Error())
  #   }
  #   # We limit perPage to 100
  #   if perPage > 100 {
  #     return []PAINTrans{}, errors.New("payments.ListTransactions: Cannot retrieve more than 100 results per request")
  #   }

  #   result, err = getTransactionList(tokenUserAccountNumber, (page * perPage), perPage)
  #   if err != nil {
  #     return []PAINTrans{}, errors.New("payments.ListTransactions: " + err.Error())
  #   }

  #   return
  # }

end
