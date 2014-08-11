class Dashing.MongodbWidget extends Dashing.Widget
  @accessor 'mongodb-available', ->
    @get('mongodb_avaialbe')

  @accessor 'documents-count', ->
    if @get('mongodb_avaialbe') then 0 else @get('documents_count')

  create_document: ->
    $.ajax('/mongodb', {type: 'POST', error: -> alert('Error creating document.') })
