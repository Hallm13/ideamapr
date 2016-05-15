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
    expect(_.isEqual(coll.detailsString(), ['123','abc'])).toBe(true)
