import { openForm } from "../utils/open-form";
import { becomeCardClickable } from "../utils/card-clickable";

$(document).ready(function() {

  $(".cards").sortable({
    connectWith: ".cards",
    placeholder: "card-placeholder",
    cursor: "move",
    revert: 300,  
    delay: 0,     
    tolerance: "pointer",
    helper: "clone",  
    opacity: 0.8,     
    start: function(e, ui) {
      ui.placeholder.height(ui.item.height());
      ui.helper.css('z-index', 100);
    },
    stop: function(e, ui) {
      ui.item.css('transform', '');
    },
    update: function(event, ui) {
      if (this === ui.item.parent()[0]) {
        var cardId = ui.item.data('card-id');
        var newPosition = ui.item.index();
        var newBoardItemId = ui.item.closest('.column').data('board-item-id');
        var boardId = $('#kanban-board').data('board-id');
        var moveUrl = '/boards/' + boardId + '/board_items/' + newBoardItemId + '/cards/' + cardId + '/move';

        $.ajax({
          url: moveUrl,
          method: 'PATCH',
          data: {
            position: newPosition + 1,
            board_item_id: newBoardItemId
          },
          success: function() {
            console.log('Card movido com sucesso.');
            var lastColumnId = $('.column').last().data('board-item-id');
            if (newBoardItemId == lastColumnId) {
              ui.item.find('.complete-card-button').hide();
              ui.item.find('.complete-card-button-mobile').prop('checked', true);
            } else {
              ui.item.find('.complete-card-button').show();
              ui.item.find('.complete-card-button-mobile').prop('checked', false);

            }
          },
          error: function() {
            alert('Erro ao mover o card.');
          }
        });
      }
    }
  }).disableSelection();

  $(document).on('click', '.complete-card-button', function(e) {
    e.stopPropagation(); 
    var button = $(this);
    var card = button.closest('.card');
    var lastColumn = $('.column').last();
    var lastColumnId = lastColumn.data('board-item-id');
    var boardId = $('#kanban-board').data('board-id');
    var cardId = card.data('card-id');

    card.addClass('processing-card');

    // Construir a URL para a rota move
    var moveUrl = '/boards/' + boardId + '/board_items/' + lastColumnId + '/cards/' + cardId + '/move';
    // Calcular a posição final na última coluna
    var newPosition = lastColumn.find('.card').not('.new-card').length + 1;

    // Criar uma cópia do card para animação
    var cardClone = card.clone();
    cardClone.css({
      position: 'absolute',
      top: card.offset().top,
      left: card.offset().left,
      width: card.width(),
      zIndex: 1000
    });
    $('body').append(cardClone);

    // Obter a posição do destino
    var targetPosition = lastColumn.find('.cards').offset();

    cardClone.animate({
      top: targetPosition.top,
      left: targetPosition.left,
      width: lastColumn.find('.cards').width()
    }, 500, function() {
      cardClone.remove(); // Remove a cópia após a animação
    });

    $.ajax({
      url: moveUrl,
      method: 'PATCH',
      data: {
        board_item_id: lastColumnId,
        position: newPosition
      },
      success: function() {
        card.fadeOut(300, function() {
          card.remove();
          lastColumn.find('.cards').append(card);
          card.fadeIn(300);
          card.removeClass('processing-card');
          // Remover os botões de concluir e editar, já que está na última coluna
          card.find('.complete-card-button').hide();
          becomeCardClickable(card)
        });
        console.log('Card concluído e movido com sucesso.');

      },
      error: function() {
        // Remover a classe de processamento em caso de erro
        card.removeClass('processing-card');
        alert('Erro ao concluir o card.');
      }
    });
  });

  $(document).on('keypress', '.card-title-input', function(e) {
    if (e.which == 13) { 
      e.preventDefault();
      var form = $(this).closest('form');
      var column = form.closest('.column');

      // Enviar requisição AJAX para criar o card
      $.ajax({
        url: form.attr('action'),
        method: 'POST',
        data: form.serialize(),
        dataType: 'json',
        success: function(response) {
          if (response.success) {
            var newCard = $(response.rendered_card).hide(); 
            column.find('.cards').prepend(newCard);
            newCard.fadeIn(300);
            form.find('.card-title-input').val('');
            form.closest('.new-card-form').hide();
            column.find('.add-card-button').show();
            becomeCardContentClickable()
            $(".cards").sortable("refresh");

            if(response.open_form){
              openForm(newCard, response.card.id)
            }

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

  $(document).on('click', function(e) {
      var target = $(e.target);
      if (!target.closest('.new-card-form').length && !target.closest('.show-new-card-form').length) {
          $('.new-card-form').hide();
          $('.add-card-button').show();
      }
  });

  $(document).on('click', '.delete-card-button', function(e) {
      e.stopPropagation();
      var card = $(this).closest('.card');
      var cardId = card.data('card-id');
      var boardItemId = card.closest('.column').data('board-item-id');
      var boardId = $('#kanban-board').data('board-id');
  
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
    
  $(document).on('click', '.edit-card-button', function(e) {
      e.stopPropagation()
      var card = $(this).closest('.card'); 
      var cardId = card.data('card-id');        
      openForm(card, cardId);     
  })

  function becomeCardContentClickable(){
    $(".card-content").on("click", function(e) {
      e.stopPropagation()
      var card = $(this); 
      var cardId = card.data('card-id');        
      openForm(card, cardId);        
    });
  }

  becomeCardContentClickable()
})

