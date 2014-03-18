GiphyView = require './giphy-view'

module.exports =
  giphyView: null

  activate: (state) ->
    @giphyView = new GiphyView(state.giphyViewState)

  deactivate: ->
    @giphyView.destroy()

  serialize: ->
    giphyViewState: @giphyView.serialize()
