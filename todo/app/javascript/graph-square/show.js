$(document).ready(function () {
    $('.graph-square').on('click', function () {
        var boardId = $(this).data('board-id');
        var cardId = $(this).data('card-id');

        if (boardId) {
            var url = '/boards/' + boardId;
            if (cardId) {
                url += '?highlight_card=' + cardId;
            }
            window.location.href = url;
        }
    });
});
