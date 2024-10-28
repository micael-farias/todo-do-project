export const timeBeforeOpeningFormAgain = 3000

export function becomeCardClickable(card) {
    $(".card-content").on("click", function (e) {
        e.stopPropagation()
        var cardId = card.data('card-id');
        var boardId = $('#kanban-board').data('board-id');
        var boardItemId = card.closest('.column').data('board-item-id');
        openForm(boardId, boardItemId, cardId);
    });
}

export function openForm(boardId, boardItemId, cardId) {
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