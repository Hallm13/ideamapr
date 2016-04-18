IdeaMapr.Views.IdeaView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')
    this.listenTo(this.model, "sync", this.render)

  events: 
    'click .addnote': (evt) ->
      $(evt.target).closest('.note-holder').find('textarea').toggle()
      
  render: ->
    template = _.template($('#idea-template').html())
    data = this.model.attributes
    data['note_counts'] =
      pro: this.model.get('pro')
      con: this.model.get('con')
            
    this.$el.html(template(data))
    this.$('textarea').hide()
    this
    
  create_entry: (type) ->
    this.model.increment_note type
    this.render()
