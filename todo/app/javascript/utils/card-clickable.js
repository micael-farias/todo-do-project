import { openForm } from "./open-form";

export function becomeCardClickable(card) {
    $(".card-content").on("click", function (e) {
        e.stopPropagation()
        var cardId = card.data('card-id');
        var boardId = $('#kanban-board').data('board-id');
        var boardItemId = card.closest('.column').data('board-item-id');
        openForm(boardId, boardItemId, cardId);
    });
}