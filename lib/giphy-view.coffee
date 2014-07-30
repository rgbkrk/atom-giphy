{$, View, EditorView} = require 'atom'

giphy_public_beta_key = "dc6zaTOxFJmzC"

module.exports =
class GiphyView extends View
  @content: ->
    @div class: 'giphy overlay from-bottom', =>
      @div click: "destroy", class: "block", =>
        @h1 class: "inline-block", "GIPHY"
        @p class: "text-subtle inline-block", "click image to copy to clipboard"
      @img outlet: "image", class: "block giph", click: 'copy'
      @div class: "block", =>
        @button class: 'btn btn-primary inline-block', click: 'random', 'NEW GIF PLEASE'
        @button class: 'btn inline-block', click: 'destroy', 'CLOSE ME'
        @span class: 'inline-block', =>
          @subview 'searchTerm', new EditorView(mini: true)
        @button class: 'btn inline-block', click: 'search', 'SEARCH PLZ'

  initialize: (serializeState) ->
    atom.workspaceView.command "giphy:random", => @random()
    atom.workspaceView.command "giphy:goaway", => @destroy()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  copy: ->
    atom.clipboard.write(@image.attr('src'))

  # Tear down any state and detach
  destroy: ->
    @detach()

  random_response_callback: (data) =>
    image_url = data["data"]["image_original_url"]
    @image.attr("src", image_url)

  random: ->
    giphy_key = giphy_public_beta_key

    xhr = $.get("http://api.giphy.com/v1/gifs/random?api_key=" + giphy_key);
    xhr.done(@random_response_callback)

    if not @hasParent()
      console.log("FRESHEN UP!")
      atom.workspaceView.append(this)
    else
      console.log("MOAR IMAGEZ")

  search: ->
    term = encodeURIComponent(@searchTerm.getEditor().getText())

    $.get("http://api.giphy.com/v1/gifs/search?q=#{term}&limit=1&api_key=#{giphy_public_beta_key}").done (data) =>
      image_url = data["data"][0]["images"]["original"]["url"]
      @image.attr('src', image_url)
