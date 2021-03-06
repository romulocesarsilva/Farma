class Carrie.Views.Lo extends Backbone.Marionette.ItemView
  template: 'los/show'
  tagName: 'article'
  className: 'header'

  onRender: ->
    @el.id = @model.get('id')
    $(@el).find('span.icon i').tooltip()

  events:
    'click .edit-lo' : 'edit_lo'
    'click .destroy-lo' : 'destroy_lo'
    'click .view-lo-btn' : 'viewLo'
    'click .contents-btn' : 'viewContents'

  viewLo: (ev) ->
    ev.preventDefault()
    url = "/published/los/#{@model.get('id')}"
    Backbone.history.navigate(url, true)

  viewContents: (ev) ->
    ev.preventDefault()
    url = "/lo-contents/#{@model.get('id')}"
    Backbone.history.navigate(url, true)

  #viewIntroductions: (ev) ->
  #  ev.preventDefault()
  #  url = "/my-los/#{@model.get('id')}/introductions"
  #  Backbone.history.navigate(url, true)

  #viewExercises: (ev) ->
  #  ev.preventDefault()
  #  url = "/my-los/#{@model.get('id')}/exercises"
  #  Backbone.history.navigate(url, true)

  edit_lo: (ev) ->
    ev.preventDefault()
    Backbone.history.navigate("/my-los/edit/#{@model.get('id')}", true)

  destroy_lo: (ev) ->
    ev.preventDefault()
    msg = "Você tem certeza que deseja remover este Objeto de Aprendizagem?"

    bootbox.confirm msg, (confirmed) =>
      if confirmed
        @model.destroy
          success: (model, response) ->
            $(@el).fadeOut(800, 'linear')
            @remove
            Carrie.Helpers.Notifications.Top.success 'OA removido com sucesso!', 4000
