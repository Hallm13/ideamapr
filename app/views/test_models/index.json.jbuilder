json.array!(@test_models) do |test_model|
  json.extract! test_model, 
  json.url test_model_url(test_model, format: :json)
end
