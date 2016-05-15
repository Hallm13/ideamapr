describe "Idea Manager", ->
  it '#distribute', ->
    t = new IdeaMapr.Views.IdeaManager()
    t.collection = new IdeaMapr.Collections.IdeaCollection()
    m1 = new IdeaMapr.Models.Idea()
    m1.set('is_assigned', true)
    m2 = new IdeaMapr.Models.Idea()
    m2.set('is_assigned', false)
    m3 = new IdeaMapr.Models.Idea()
    m3.set('is_assigned', false)
    t.collection.add m1
    t.collection.add m2
    t.collection.add m3
    t.distribute({render: false})
    
    expect(t.selected_view.collection.length).toBe(1)
    expect(t.search_view.collection.length).toBe(2)

