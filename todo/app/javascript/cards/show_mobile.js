
  // C$(document).ready(function() {
$(document).ready(function() {
    // Enviar formulário de edição via AJAX

$(document).on('change', '.complete-card-button-mobile', function(e) {
  e.stopPropagation();
  var checkbox = $(this);
  var isChecked = checkbox.is(':checked');
  var card = checkbox.closest('.card, .card-mobile');
  var cardId = card.data('card-id');
  var boardId = $('.mobile-view').data('board-id');
  var boardItemId = card.data('board-item-id');

  // Send AJAX request to toggle completion
  $.ajax({
    url: `/boards/${boardId}/board_items/${boardItemId}/cards/${cardId}/toggle_complete`,
    method: 'PATCH',
    data: { completed: isChecked },
    success: function(response) {
      if (response.success) {
        console.log('Card completion status updated.');
        // Optionally, update the UI or reload the board
      } else {
        alert('Error updating card status: ' + response.message);
      }
    },
    error: function() {
      alert('Error updating card status. Please try again.');
    }
  });
});

 // Handler para o botão de adicionar card na versão móvel
  $(document).on('click', '.add-card-mobile', function(e) {
    e.stopPropagation();

    var addCardElement = $(this);

   // Substituir o conteúdo por um campo de input
    var inputField = $('<input>', {
      type: 'text',
      class: 'form-control new-card-title-input',
      placeholder: 'Digite o título do novo card'
    });

    // Remover o ícone de adição e adicionar o campo de input
    addCardElement.html(inputField);

    // Focar no campo de input
    inputField.focus();

    // Handler para pressionar Enter no campo de input
    inputField.on('keypress', function(e) {
      if (e.which == 13) { // Tecla Enter
        e.preventDefault();
        var title = $(this).val().trim();
        if (title === '') {
          alert('O título do card não pode estar vazio.');
          return;
        }

        var boardId = $('.mobile-view').data('board-id');
        var firstBoardItemId = addCardElement.data('board-item-id');

        // Enviar requisição AJAX para criar o card
        $.ajax({
          url: `/boards/${boardId}/board_items/${firstBoardItemId}/cards`,
          method: 'POST',
          data: { card: { title: title } },
          dataType: 'json',
          success: function(response) {
            if (response.success) {
                location.reload()
            } else {
              alert('Erro ao criar o card: ' + response.message);
            }
          },
          error: function() {
            alert('Erro ao criar o card. Por favor, tente novamente.');
          }
        });
      }
    });

    // Handler para clicar fora do input e cancelar a adição
    $(document).on('click.addCardInput', function(e) {
      if (!$(e.target).closest('.add-card-mobile').length) {
        // Restaurar o botão de adicionar
        addCardElement.html('<div class="card-header-mobile"><i class="bi bi-plus-lg" style="color: white"></i></div>');
        // Remover este handler
        $(document).off('click.addCardInput');
      }
    });

  });
 


    // Mostrar o formulário de novo card ao clicar no botão
    $('.show-new-card-form').on('click', function(e) {
      e.preventDefault();
      var column = $(this).closest('.column');
      column.find('.add-card-button').hide();
      column.find('.new-card-form').show();
      column.find('.card-title-input').focus();
    });


    // Handler para o botão de excluir
   // Handler para o botão de excluir
$(document).on('click', '.delete-card-button-mobile', function(e) {
  e.stopPropagation();
  var card = $(this).closest('.card, .card-mobile');
  var cardId = card.data('card-id');
  var boardItemId = card.data('board-item-id');
  var boardId = $('.mobile-view').data('board-id');

  if (confirm('Tem certeza que deseja excluir este card?')) {
    $.ajax({
      url: `/boards/${boardId}/board_items/${boardItemId}/cards/${cardId}`,
      method: 'DELETE',
      success: function() {
        card.fadeOut(300, function() {
          card.remove();
          console.log('Card excluído com sucesso.');
        });
      },
      error: function() {
        alert('Erro ao excluir o card.');
      }
    });
  }
});

  });