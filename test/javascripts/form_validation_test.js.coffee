describe 'Form validation function tests', ->
  beforeEach ->
    affix "input.validated-box[data-expected-length='10'][type='text']"
    affix "textarea.validated-box[data-expected-length='15']"
    
  it 'checks validated boxes for false', ->
    expect(window.run_validations()).toBe(false)
    
  it 'checks validated boxes for true', ->
    $("input.validated-box[data-expected-length='10'][type='text']").val('long long long long')
    $("textarea.validated-box[data-expected-length='15']").val('long long long long')
    
    expect(window.run_validations()).toBe(true)
    $("textarea.validated-box[data-expected-length='15']").val('short')
    expect(window.run_validations()).toBe(false)
