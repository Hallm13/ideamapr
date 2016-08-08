def valid_stripe_charge_object
  {
    "id": "ch_16HMo32eZvKYlo2CN0EYDD5k",
   "object": "charge",
   "created": 1435186643,
   "livemode": false,
   "paid": true,
   "status": "succeeded",
   "amount": 5000,
   "currency": "usd",
   "refunded": false,
   "source": {
               "id": "card_16HMo02eZvKYlo2CfsizBfho",
              "object": "card",
              "last4": "4242",
              "brand": "Visa",
              "funding": "credit",
              "exp_month": 12,
              "exp_year": 2016,
              "country": "US",
              "name": "gbr_brad@hotmail.com",
              "address_line1": nil,
              "address_line2": nil,
              "address_city": nil,
              "address_state": nil,
              "address_zip": nil,
              "address_country": nil,
              "cvc_check": "pass",
              "address_line1_check": nil,
              "address_zip_check": nil,
              "dynamic_last4": nil,
              "metadata": {
                          },
              "customer": "cus_6ULVKZxppyINJm"
             },
   "captured": true,
   "balance_transaction": "txn_16Esmv2eZvKYlo2CXxibx5gw",
   "failure_message": nil,
   "failure_code": nil,
   "amount_refunded": 0,
   "customer": "cus_6ULVKZxppyINJm",
   "invoice": nil,
   "description": nil,
   "dispute": nil,
   "metadata": {
               },
   "statement_descriptor": nil,
   "fraud_details": {
                    },
   "receipt_email": nil,
   "receipt_number": nil,
   "shipping": nil,
   "destination": nil,
   "application_fee": nil,
   "refunds": {
                "object": "list",
               "total_count": 0,
               "has_more": false,
               "url": "/v1/charges/ch_16HMo32eZvKYlo2CN0EYDD5k/refunds",
               "data": [

                       ]
              }
  }.to_json
end

def stripe_headers
  {'Accept'=>'*/*; q=0.5, application/xml'}
end

def set_net_stubs
  stub_request(:put, "https://testbucket.s3.testregion.amazonaws.com/image.png").
    to_return(status: 200)
  stub_request(:put, "https://testbucket.s3.testregion.amazonaws.com/dummy_name.png").
    to_return(status: 200)
end

