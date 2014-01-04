# Define custom directive
Horn.addDirective "data-click-with-trigger", (view) ->
  $el = view.$("[data-click-with-trigger]")
  $el.on 'click', (e) =>
    eventName = $(e.target).data('click-with-trigger')
    view.trigger eventName

Horn.registerTemplate """
  <div
    data-template-name="layout"
    data-attrs="">
    <h1>todo</h1>
    <div class="input-container" />
    <div class="todo-container" />
  </div>
"""

Horn.registerTemplate """
  <li
    data-template-name="todo"
    data-attrs="title, checked">
    <button data-click="deleteThis">☓</button>
    <span data-text="title"></span>
  </li>
"""

Horn.registerTemplate """
  <div
    data-template-name="input"
    data-attrs="title">

    <input type="text" width=120/>
    <button data-click="addItem">post</button>
  </div>
"""

class Layout extends Horn.View
  templateName: 'layout'

class Todo extends Horn.View
  templateName: 'todo'

  deleteThis: ->
    @dispose()

class TodoList extends Horn.ListView
  itemView: Todo

class Input extends Horn.View
  templateName: 'input'
  className: 'ul'
  addItem: ->
    text = @$('input').val()
    return unless text
    @trigger 'addItem', [text]
    @$('input').val('')

$ ->
  layout = new Layout
  layout.attach 'body'

  input = new Input
  input.attach layout.$('.input-container')

  list = new TodoList
  list.attach layout.$('.todo-container')

  input.on 'addItem', (e, title) ->
    list.addItem title: title
