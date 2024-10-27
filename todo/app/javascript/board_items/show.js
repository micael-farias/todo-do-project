import { consolidateColumnEdit } from "./save";

$(document).ready(function() {
  $('#kanban-board').on('click', '.column-name', function() {
    var span = $(this);
    var currentName = span.text();

    // Criar um campo de input com o nome atual
    var input = $('<input>', {
      type: 'text',
      class: 'form-control column-name-input',
      value: currentName
    });

    // Substituir o span pelo input
    span.replaceWith(input);
    input.focus();

    // Selecionar o texto no input
    input.select();
    });

  $('#kanban-board').on('keydown', '.column-name-input', function(e) {
      var input = $(this);
      if (e.which == 13) { 
        e.preventDefault();
        consolidateColumnEdit(input);
      }
  });

  $(document).on('click', '.delete-column-button', function(e) {
    e.stopPropagation(); 
    var button = $(this);
    var columnId = button.data('column-id');
    var column = button.closest('.column');

    var hasCards = column.find('.card').length > 0;
    var confirmationMessage = hasCards ? 
      'Esta coluna contém cards. Ao excluir a coluna, todos os cards também serão excluídos. Deseja continuar?' : 
      'Tem certeza que deseja excluir esta coluna?';

    if (confirm(confirmationMessage)) {
      var boardId = $('#kanban-board').data('board-id');
      var deleteUrl = '/boards/' + boardId + '/board_items/' + columnId;

      $.ajax({
        url: deleteUrl,
        method: 'DELETE',
        success: function(response) {
          if (response.success) {
            column.fadeOut(300, function() {
              $(this).remove();
            });
          } else {
            alert('Erro ao excluir a coluna: ' + response.message);
          }
        },
        error: function() {
          alert('Erro ao excluir a coluna. Por favor, tente novamente.');
        }
      });
    }
  });

  $('.show-new-card-form').on('click', function(e) {
    e.preventDefault();
    var column = $(this).closest('.column');
    column.find('.add-card-button').hide();
    column.find('.new-card-form').show();
    column.find('.card-title-input').focus();
  });
})