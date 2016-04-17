IdeaMapr.Views.IdeaView = Backbone.View.extend
  initialize: ->
    _.bindAll(this, 'render')

    this.listenTo(this.model, "sync", this.render)

  events: 
    'click .addpro': ->
      this.create_entry('pro')
    'click .addcon': ->
      this.create_entry('con')
      
  render: ->
    template = _.template($('#idea-template').html())
    data = this.model.attributes
    data['note_counts'] =
      pro: this.model.get('pro')
      con: this.model.get('con')
            
    this.$el.html(template(data))

  create_entry: (type) ->
    this.model.increment_note type
    this.render()
