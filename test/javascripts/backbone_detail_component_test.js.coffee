describe "Detail Component", ->
  it 'initializes', ->
    t = new IdeaMapr.Models.DetailComponent()
    expect(t.get('is_edited')).toBe(false)
  it 'sets edited state', ->
    t = new IdeaMapr.Models.DetailComponent()
    t.set_edited_state('newtext')
    expect(t.original_text).toBe('Click to Add')
    expect(t.get('text')).toBe('newtext')
    expect(t.get('is_edited')).toBe(true)
