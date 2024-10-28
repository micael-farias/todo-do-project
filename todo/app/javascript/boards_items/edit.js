
export function updateColumn(columnId, newName, boardId, input) {
  $.ajax({
    url: `/boards/${boardId}/board_items/${columnId}`,
    method: 'PATCH',
    data: { board_item: { name: newName } },
    dataType: 'json',
    success: function (response) {
      if (response.success) {
        replaceInputWithColumnName(input, columnId, response.board_item.name);
      } else {
        alert('Erro ao atualizar o nome da coluna: ' + response.message);
      }
    },
    error: function () {
      alert('Erro ao atualizar o nome da coluna. Por favor, tente novamente.');
    }
  });
}

function replaceInputWithColumnName(input, columnId, updatedName) {
  var updatedSpan = $('<span>', {
    class: 'column-name',
    'data-column-id': columnId,
    text: updatedName
  });
  input.replaceWith(updatedSpan);
}