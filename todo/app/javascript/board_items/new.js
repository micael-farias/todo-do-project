export function createColumn(form) {
  $.ajax({
    url: form.attr('action'),
    method: 'POST',
    data: form.serialize(),
    dataType: 'json',
    success: function (response) {
      if (response.success) {
        addNewColumnToBoard(response.rendered_column);
        clearForm(form);
        location.reload()
      } else {
        alert('Erro ao criar a coluna: ' + response.message);
      }
    },
    error: function () {
      alert('Erro ao criar a coluna. Por favor, tente novamente.');
    }
  });
}

function addNewColumnToBoard(renderedColumn) {
  var board = $('#kanban-board');
  var newColumn = $(renderedColumn).hide();
  board.find('.add-column-button').before(newColumn);
  newColumn.fadeIn(300);
}

function clearForm(form) {
  form.find('.column-name-input').val('');
  form.closest('.new-column-form').hide();
  $('#kanban-board').find('.add-column-button').show();
}

