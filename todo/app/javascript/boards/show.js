//import { consolidateColumnEdit } from "../boards_items/save";
//import { createColumn } from "../boards_items/new";
//import { updateColumn } from "../boards_items/edit"
//import { openForm } from "../utils/consts";
//import { becomeCardClickable } from "../utils/consts";
//import { timeBeforeOpeningFormAgain } from "../utils/consts";
//import { addTag } from "../tags/add-tag";

$(document).ready(function () {
  const timeBeforeOpeningFormAgain = 3000

  function becomeCardClickable(card) {
    $(".card-content").on("click", function (e) {
      e.stopPropagation()
      var cardId = card.data('card-id');
      var boardId = $('#kanban-board').data('board-id');
      var boardItemId = card.closest('.column').data('board-item-id');
      openForm(boardId, boardItemId, cardId);
    });
  }

  function openForm(boardId, boardItemId, cardId) {
    var modal = new bootstrap.Modal(document.getElementById('editCardModal'));
    var form = $('#edit-card-form');

    form.attr('action', `/boards/${boardId}/board_items/${boardItemId}/cards/${cardId}`);

    $('#tag-container-edit').empty();
    $('#card_tags_edit').val('');

    $.ajax({
      url: `/boards/${boardId}/board_items/${boardItemId}/cards/${cardId}/edit`,
      method: 'GET',
      dataType: 'json',
      success: function (data) {
        form.find('#card_title').val(data.title);
        form.find('#card_description').val(data.description);
        form.find('#card_mood_id').val(data.mood_id || '');
        form.find('#card_due_date').val(data.due_date ? data.due_date.split('T')[0] : '');
        form.find('#card_priority').val(data.priority || '');

        if (data.tags && data.tags.length > 0) {
          data.tags.forEach(function (tag) {
            addTag(tag.name, 'tag-container-edit', 'card_tags_edit');
          });
        }

        modal.show();
      },
      error: function (jqXHR, textStatus, errorThrown) {
        alert('Erro ao carregar dados do card.');
      }
    });
  }
  function addTag(tag, containerId, hiddenFieldId) {
    tag = tag.trim();
    if (tag === '') return;

    var existingTags = $(`#${containerId} .tag-badge`).map(function () {
      return $(this).data('tag').toLowerCase();
    }).get();

    if (existingTags.includes(tag.toLowerCase())) {
      return;
    }

    var tagBadge = $(`
    <span class="tag-badge" data-tag="${tag}">
        ${tag}
        <span class="remove-tag text-light">&times;</span>
    </span>
    `);

    $(`#${containerId}`).append(tagBadge);

    var currentTags = $(`#${hiddenFieldId}`).val();
    if (currentTags) {
      $(`#${hiddenFieldId}`).val(currentTags + ',' + tag);
    } else {
      $(`#${hiddenFieldId}`).val(tag);
    }
  }
  $('#duplicate-board-button').on('click', function (e) {
    e.preventDefault();

    if (confirm('Tem certeza que deseja duplicar este board? As colunas serão duplicadas, mas os cards não.')) {
      var boardId = $('#kanban-board').data('board-id');

      $.ajax({
        url: '/boards/' + boardId + '/duplicate',
        method: 'POST',
        success: function (response) {
          if (response.success) {
            window.location.href = '/boards/' + response.new_board_id;
          } else {
            alert('Erro ao duplicar o board: ' + response.message);
          }
        },
        error: function () {
          alert('Erro ao duplicar o board. Por favor, tente novamente.');
        }
      });
    }
  });

  $('#delete-board-button').on('click', function (e) {
    e.preventDefault();

    if (confirm('Tem certeza que deseja excluir este board? Todas as colunas e cards associados também serão excluídos.')) {
      var boardId = $('#kanban-board').data('board-id');

      $.ajax({
        url: '/boards/' + boardId,
        method: 'DELETE',
        success: function (response) {
          if (response.success) {
            window.location.href = '/';
          } else {
            alert('Erro ao excluir o board: ' + response.message);
          }
        },
        error: function () {
          alert('Erro ao excluir o board. Por favor, tente novamente.');
        }
      });
    }
  });

  $(document).on('click', function (e) {
    var target = $(e.target);

    if (!target.closest('.new-column-form').length && !target.closest('.add-column-button').length) {
      $('.new-column-form').hide();
      $('.add-column-button').show();
    }

    if (!target.closest('.board-edit-container').length && !target.closest('.board-title').length) {
      $('.board-edit-container').each(function () {
        var inputGroup = $(this);
        var input = inputGroup.find('.board-edit-title-input');
        var originalName = input.data('original-name');
        replaceInputWithBoardTitle(inputGroup, originalName);
      });
    }


  });

  $('.show-new-column-form').on('click', function (e) {
    e.preventDefault();
    var board = $('#kanban-board');
    board.find('.add-column-button').hide();
    board.find('.new-column-form').show();
    board.find('.column-name-input').focus();
  });

  $(document).on('click', '.board-title', function () {
    var span = $(this);
    var currentName = span.text().trim();
    var boardId = span.data('board-id');

    var editInputGroup = createEditInput(currentName, boardId);
    span.replaceWith(editInputGroup);

    input.focus();
    input.select();
  });

  function createEditInput(currentName, boardId) {
    var inputGroup = $('<div>', { class: 'input-group board-edit-container', style: 'width: 80%; padding: 10px 0px 10px 0px' });

    var input = $('<input>', {
      type: 'text',
      class: 'form-control board-edit-title-input',
      value: currentName,
      'data-original-name': currentName,
      'data-board-id': boardId,
      'aria-label': 'Título do Board'
    });

    var button = $('<button>', {
      class: 'btn btn-success board-save-title-button',
      type: 'button',
      'aria-label': 'Concluir Edição'
    }).html('<i class="bi bi-check"></i>');

    inputGroup.append(input);
    inputGroup.append(button);

    return inputGroup;
  }

  $(document).on('click', '.board-save-title-button', function () {
    var button = $(this);
    var inputGroup = button.closest('.board-edit-container');
    var input = inputGroup.find('.board-edit-title-input');
    var newName = input.val().trim();
    var boardId = input.data('board-id');

    if (newName === "") {
      alert('O título do board não pode estar vazio.');
      input.focus();
      return;
    }

    updateBoardTitle(boardId, newName, inputGroup);
  });

  $(document).on('keydown', '.board-edit-title-input', function (e) {
    if (e.which == 13) { // Enter key
      e.preventDefault();
      var input = $(this);
      var inputGroup = input.closest('.board-edit-container');
      var newName = input.val().trim();
      var boardId = input.data('board-id');

      if (newName === "") {
        alert('O título do board não pode estar vazio.');
        input.focus();
        return;
      }

      // Enviar a atualização via AJAX
      updateBoardTitle(boardId, newName, inputGroup);
    }
  });

  function updateBoardTitle(boardId, newName, inputGroup) {
    $.ajax({
      url: `/boards/${boardId}`,
      method: 'PATCH',
      data: { board: { title: newName } },
      dataType: 'json',
      success: function (response) {
        if (response.success) {
          replaceInputWithBoardTitle(inputGroup, response.board.title);
        } else {
          alert('Erro ao atualizar o título do board: ' + response.message);
          replaceInputWithBoardTitle(inputGroup, inputGroup.find('.board-edit-title-input').data('original-name'));
        }
      },
      error: function () {
        alert('Erro ao atualizar o título do board. Por favor, tente novamente.');
        replaceInputWithBoardTitle(inputGroup, inputGroup.find('.board-edit-title-input').data('original-name'));
      }
    });
  }

  function replaceInputWithBoardTitle(inputGroup, updatedName) {
    var boardId = inputGroup.find('.board-edit-title-input').data('board-id');
    var updatedSpan = $('<span>', {
      class: 'board-title',
      'data-board-id': boardId,
      text: updatedName,
      style: 'cursor: pointer;'
    });
    inputGroup.replaceWith(updatedSpan);
  }

  $('#kanban-board').on('click', '.column-name', function () {
    var span = $(this);
    var currentName = span.text();

    var input = $('<input>', {
      type: 'text',
      class: 'form-control column-name-input',
      value: currentName
    });

    span.replaceWith(input);
    input.focus();

    input.select();
  });

  $('#kanban-board').on('keydown', '.column-name-input', function (e) {
    var input = $(this);
    if (e.which == 13) {
      e.preventDefault();
      var newName = input.val().trim();
      if (newName === "") return;

      var columnId = input.closest('.column').data('board-item-id');
      var boardId = $('#kanban-board').data('board-id');

      if (columnId === undefined) {
        createColumn(input.closest('form'), newName);
      } else {
        updateColumn(columnId, newName, boardId, input);
      }
    }
  });

  $(document).on('click', '.delete-column-button', function (e) {
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
        success: function (response) {
          if (response.success) {
            column.fadeOut(300, function () {
              $(this).remove();
            });
          } else {
            alert('Erro ao excluir a coluna: ' + response.message);
          }
        },
        error: function () {
          alert('Erro ao excluir a coluna. Por favor, tente novamente.');
        }
      });
    }
  });

  $('.show-new-card-form').on('click', function (e) {
    e.preventDefault();
    var column = $(this).closest('.column');
    column.find('.add-card-button').hide();
    column.find('.new-card-form').show();
    column.find('.card-title-input').focus();
  });


  function updateColumn(columnId, newName, boardId, input) {
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

  function createColumn(form) {
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


  $(".cards").sortable({
    connectWith: ".cards",
    placeholder: "card-placeholder",
    cursor: "move",
    revert: 300,
    delay: 0,
    tolerance: "pointer",
    helper: "clone",
    opacity: 0.8,
    start: function (e, ui) {
      ui.placeholder.height(ui.item.height());
      ui.helper.css('z-index', 100);
    },
    stop: function (e, ui) {
      ui.item.css('transform', '');
    },
    update: function (event, ui) {
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
          success: function () {
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
          error: function () {
            alert('Erro ao mover o card.');
          }
        });
      }
    }
  }).disableSelection();

  $(document).on('click', '.complete-card-button', function (e) {
    e.stopPropagation();
    var button = $(this);
    var card = button.closest('.card');
    var lastColumn = $('.column').last();
    var lastColumnId = lastColumn.data('board-item-id');
    var boardId = $('#kanban-board').data('board-id');
    var cardId = card.data('card-id');

    card.addClass('processing-card');

    var moveUrl = '/boards/' + boardId + '/board_items/' + lastColumnId + '/cards/' + cardId + '/move';
    var newPosition = lastColumn.find('.card').not('.new-card').length + 1;

    var cardClone = card.clone();
    cardClone.css({
      position: 'absolute',
      top: card.offset().top,
      left: card.offset().left,
      width: card.width(),
      zIndex: 1000
    });
    $('body').append(cardClone);

    var targetPosition = lastColumn.find('.cards').offset();

    cardClone.animate({
      top: targetPosition.top,
      left: targetPosition.left,
      width: lastColumn.find('.cards').width()
    }, 500, function () {
      cardClone.remove();
    });

    $.ajax({
      url: moveUrl,
      method: 'PATCH',
      data: {
        board_item_id: lastColumnId,
        position: newPosition
      },
      success: function () {
        card.fadeOut(300, function () {
          card.remove();
          lastColumn.find('.cards').append(card);
          card.fadeIn(300);
          card.removeClass('processing-card');
          card.find('.complete-card-button').hide();
          becomeCardClickable(card)
        });
        console.log('Card concluído e movido com sucesso.');

      },
      error: function () {
        card.removeClass('processing-card');
        alert('Erro ao concluir o card.');
      }
    });
  });

  $(document).on('keypress', '.card-title-input', function (e) {
    if (e.which == 13) {
      e.preventDefault();
      var form = $(this).closest('form');
      var column = form.closest('.column');

      $.ajax({
        url: form.attr('action'),
        method: 'POST',
        data: form.serialize(),
        dataType: 'json',
        success: function (response) {
          if (response.success) {
            var newCard = $(response.rendered_card).hide();
            column.find('.cards').prepend(newCard);
            newCard.fadeIn(300);
            form.find('.card-title-input').val('');
            form.closest('.new-card-form').hide();
            column.find('.add-card-button').show();
            becomeCardContentClickable()
            $(".cards").sortable("refresh");

            if (response.open_form) {
              var boardId = $('#kanban-board').data('board-id');
              var boardItemId = newCard.closest('.column').data('board-item-id');
              openForm(boardId, boardItemId, cardId);
            }

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

  $(document).on('click', function (e) {
    var target = $(e.target);
    if (!target.closest('.new-card-form').length && !target.closest('.show-new-card-form').length) {
      $('.new-card-form').hide();
      $('.add-card-button').show();
    }
  });

  $(document).on('click', '.delete-card-button', function (e) {
    e.stopPropagation();
    var card = $(this).closest('.card');
    var cardId = card.data('card-id');
    var boardItemId = card.closest('.column').data('board-item-id');
    var boardId = $('#kanban-board').data('board-id');

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


  $(document).on('click', '.edit-card-button', function (e) {
    e.stopPropagation()

    var currentTime = new Date().getTime();
    if (currentTime - lastFormOpenTime < timeBeforeOpeningFormAgain) {
      return;
    }

    lastFormOpenTime = currentTime;

    var card = $(this).closest('.card');
    var cardId = card.data('card-id');
    var boardId = $('#kanban-board').data('board-id');
    var boardItemId = card.closest('.column').data('board-item-id');
    openForm(boardId, boardItemId, cardId);
  })

  function becomeCardContentClickable() {
    $(".card-content").on("click", function (e) {
      e.stopPropagation()

      var currentTime = new Date().getTime();
      if (currentTime - lastFormOpenTime < timeBeforeOpeningFormAgain) {
        return;
      }

      lastFormOpenTime = currentTime;

      var card = $(this);
      var cardId = card.data('card-id');
      var boardId = $('#kanban-board').data('board-id');
      var boardItemId = card.closest('.column').data('board-item-id');
      openForm(boardId, boardItemId, cardId);
    });
  }

  becomeCardContentClickable()











  function removeTag(tag, containerId, hiddenFieldId) {
    $(`#${containerId} .tag-badge[data-tag="${tag}"]`).remove();

    var currentTags = $(`#${hiddenFieldId}`).val().split(',');
    var updatedTags = currentTags.filter(function (t) {
      return t.trim().toLowerCase() !== tag.trim().toLowerCase();
    });
    $(`#${hiddenFieldId}`).val(updatedTags.join(','));
  }

  $('#tag-input-new').on('keypress', function (e) {
    if (e.which == 13) {
      e.preventDefault();
      var tag = $(this).val();
      addTag(tag, 'tag-container-new', 'card_tags_new');
      $(this).val('');
    }
  });

  $('#tag-container-new').on('click', '.remove-tag', function () {
    var tag = $(this).parent().data('tag');
    removeTag(tag, 'tag-container-new', 'card_tags_new');
  });

  $('#tag-input-edit').on('keypress', function (e) {
    if (e.which == 13) {
      e.preventDefault();
      var tag = $(this).val();
      addTag(tag, 'tag-container-edit', 'card_tags_edit');
      $(this).val('');
    }
  });

  $('#tag-container-edit').on('click', '.remove-tag', function () {
    var tag = $(this).parent().data('tag');
    removeTag(tag, 'tag-container-edit', 'card_tags_edit');
  });

  $('#edit-card-form').on('submit', function (e) {
    e.preventDefault();
    var form = $(this);
    var formData = form.serialize();

    $.ajax({
      url: form.attr('action'),
      method: 'PATCH',
      data: formData,
      dataType: 'json',
      success: function (data) {
        console.log(data.card.mood);
        if (data.success) {
          sessionStorage.setItem('scrollPosition', $(window).scrollTop());

          var url = new URL(window.location.href);
          url.searchParams.delete('highlight_card');

          window.history.replaceState({}, document.title, url.pathname + url.search);

          location.reload();
        } else {
          alert('Erro ao atualizar o card: ' + data.message);
        }

      },
      error: function () {
        alert('Erro ao atualizar o card. Por favor, tente novamente.');
      }
    });
  });


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



})