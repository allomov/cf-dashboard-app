class Dashing.MongodbWidget extends Dashing.Widget
  @accessor 'mongodb-available', ->
    @get('mongodb_available')

  @accessor 'documents-count', ->
    if @get('mongodb_available') then @get('documents_count') else 0

  create_document: ->
    $.ajax('/mongodb', {type: 'POST', error: -> alert('Error creating document.') })
