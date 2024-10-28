import { openForm } from "../utils/consts";
import { timeBeforeOpeningFormAgain } from "../utils/consts";

$(document).ready(function () {

  $(document).on('change', '.complete-card-button-mobile', function (e) {
    e.stopPropagation();
    var checkbox = $(this);
    var isChecked = checkbox.is(':checked');
    var card = checkbox.closest('.card, .card-mobile');
    var cardId = card.data('card-id');
    var boardId = $('.mobile-view').data('board-id');
    var boardItemId = card.data('board-item-id');

    $.ajax({
      url: `/boards/${boardId}/board_items/${boardItemId}/cards/${cardId}/toggle_complete`,
      method: 'PATCH',
      data: { completed: isChecked },
      success: function (response) {
        if (response.success) {
          console.log('Card completion status updated.');
        } else {
          alert('Error updating card status: ' + response.message);
        }
      },
      error: function () {
        alert('Error updating card status. Please try again.');
      }
    });
  });

  let lastFormOpenTime = 0;

  $(document).on('click', '.card-title-mobile', function (e) {
    e.stopPropagation()

    var currentTime = new Date().getTime();
    if (currentTime - lastFormOpenTime < timeBeforeOpeningFormAgain) {
        return;
    }

    lastFormOpenTime = currentTime;

    var card = $(this);
    var cardId = card.data('card-id');
    var boardId = card.data('board-id');
    var boardItemId = card.data('board-item-id');

    openForm(boardId, boardItemId, cardId);
  })

  $(document).on('click', '.add-card-mobile', function (e) {
    e.stopPropagation();

    var addCardElement = $(this);

    var inputField = $('<input>', {
      type: 'text',
      class: 'form-control new-card-title-input',
      placeholder: 'Digite o título do novo card e pressione enter'
    });

    addCardElement.html(inputField);

    inputField.focus();

    inputField.on('keypress', function (e) {
      if (e.which == 13) {
        e.preventDefault();
        var title = $(this).val().trim();
        if (title === '') {
          alert('O título do card não pode estar vazio.');
          return;
        }

        var boardId = $('.mobile-view').data('board-id');
        var firstBoardItemId = addCardElement.data('board-item-id');

        $.ajax({
          url: `/boards/${boardId}/board_items/${firstBoardItemId}/cards`,
          method: 'POST',
          data: { card: { title: title } },
          dataType: 'json',
          success: function (response) {
            if (response.success) {
              location.reload()
            } else {
              alert('Erro ao criar o card: ' + response.message);
            }
          },
          error: function () {
            alert('Erro ao criar o card. Por favor, tente novamente.');
          }
        });
      }
    });

    $(document).on('click.addCardInput', function (e) {
      if (!$(e.target).closest('.add-card-mobile').length) {
        addCardElement.html('<div class="card-header-mobile"><i class="bi bi-plus-lg" style="color: white"></i></div>');
        $(document).off('click.addCardInput');
      }
    });

  });

  $('.show-new-card-form').on('click', function (e) {
    e.preventDefault();
    var column = $(this).closest('.column');
    column.find('.add-card-button').hide();
    column.find('.new-card-form').show();
    column.find('.card-title-input').focus();
  });


  $(document).on('click', '.delete-card-button-mobile', function (e) {
    e.stopPropagation();
    var card = $(this).closest('.card, .card-mobile');
    var cardId = card.data('card-id');
    var boardItemId = card.data('board-item-id');
    var boardId = $('.mobile-view').data('board-id');

    if (confirm('Tem certeza que deseja excluir este card?')) {
      $.ajax({
        url: `/boards/${boardId}/board_items/${boardItemId}/cards/${cardId}`,
        method: 'DELETE',
        success: function () {
          card.fadeOut(300, function () {
            card.remove();
            console.log('Card excluído com sucesso.');
          });
        },
        error: function () {
          alert('Erro ao excluir o card.');
        }
      });
    }
  });

});