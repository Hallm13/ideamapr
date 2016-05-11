IdeaMapr.Collections.RankedIdeaCollection = IdeaMapr.Collections.IdeaCollection.extend
  post_initialize: ->
    model_self = this
    this.ranked_count = 0
    _.each(this.models, (m, idx) ->
      m.is_ranked = false
      m.set('idea_rank',  -1 * (1 + idx))
      model_self.listenTo m, 'idea:moved_to_ranked', model_self.reset_and_sort
      model_self.listenTo m, 'idea:change_rank', model_self.reset_and_sort
    )
    return

  reset_and_sort: (model, options) ->
    switch options['action']
      when 'rank-it'
        model.is_ranked = true
        this.ranked_count += 1
        model.set('idea_rank', this.ranked_count)
        model.trigger('idea:finish_move_to_top')
      when 'change-rank'
        current_rank = this.get('idea_rank')
        if options['direction'] == '+'
          # Ignore the + click on the top idea
          if current_rank == 1
            return
          new_rank = current_rank - 1
        else
          # Ignore the - click on the last ranked idea
          if current_rank == this.ranked_count
            return
          new_rank = current_rank + 1

        # Now, change the old model's rank that the new model aspires to
        _.each(this.models, (m, idx) ->
          if m.get('idea_rank') == new_rank
            if options['direction'] == '+'
              m.set('idea_rank', m.get('idea_rank') + 1)
            else
              m.set('idea_rank', m.get('idea_rank') - 1)
        )
    this.sort()
    
  urlRoot: '/ideas',
  url: ->
    this.urlRoot + '?for_survey=' + this.survey_id

  comparator: (m) ->
    m.get('idea_rank')
        
  model: IdeaMapr.Models.Idea,
  save: ->
    x = this.toJSON()
    y = $('.metadata').map (i, e) ->
      _t = {}
      _t[$(e).attr('name')] = $(e).val()
      _t
    x.push y.get()

    Backbone.sync 'update', this, contentType: 'application/json', url: '/survey_responses/0', data: JSON.stringify(x)
