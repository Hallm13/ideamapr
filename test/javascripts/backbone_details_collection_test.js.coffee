describe "Details Collection", ->
  coll = null
  beforeEach ->
    coll = new IdeaMapr.Collections.DetailsCollection()

  it 'gets model string', ->
    dc1 = new IdeaMapr.Models.DetailComponent()
    dc2 = new IdeaMapr.Models.DetailComponent()
    dc1.set('text', '123')
    dc2.set('text', 'abc')
    coll.add dc1
    coll.add dc2
    view = new IdeaMapr.Views.SurveyQuestionDetailsView
      collection: coll
    
    expect(JSON.stringify(view.serialize_models()['details'])).toBe(JSON.stringify([{"text":"123","is_edited":false,"ready_for_render":0,"is_promoted":false},{"text":"abc","is_edited":false,"ready_for_render":0,"is_promoted":false}]))
