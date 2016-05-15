describe "Idea Collection", ->
  coll = null
  beforeEach ->
    coll = new IdeaMapr.Collections.IdeaCollection()

  it 'gets model string', ->
    idea1 = new IdeaMapr.Models.Idea()
    coll.add idea1
    expect(coll.models[0].get('idea_rank')).toBe(1)
    idea2 = new IdeaMapr.Models.Idea()
    coll.add idea2
    
    expect(coll.models[1].get('idea_rank')).toBe(2)
    coll.remove idea2
    coll.add idea2

    expect(coll.models.length).toBe(2)
    expect(coll.models[1].get('idea_rank')).toBe(2)

  it 'reranks correctly', ->
    idea1 = new IdeaMapr.Models.Idea()
    idea2 = new IdeaMapr.Models.Idea()
    idea3 = new IdeaMapr.Models.Idea()
    idea1.set('title', 'p')
    idea2.set('title', 'a')
    idea3.set('title', 'l')
            
    coll.add idea1; coll.add idea2; coll.add idea3;
    idea2.set('ranked', 1)
    coll.rerank_and_sort idea2, 1
    expect(coll.models[0].get('title')).toBe('a')

    idea1.set('ranked', -1)
    coll.rerank_and_sort idea1, -1
    expect(coll.models[2].get('title')).toBe('p')
