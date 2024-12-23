$(document).ready(function () {

  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });
  
  $('#duplicate-board-button').on('click', function (e) {
    e.preventDefault();

    if (confirm('Tem certeza que deseja duplicar este board? As colunas serão duplicadas, mas os cards não.')) {
      var boardId = $('.board-title').data('board-id');

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
      var boardId = $('.board-title').data('board-id');

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
})