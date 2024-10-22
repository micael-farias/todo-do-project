document.addEventListener('DOMContentLoaded', function() {
  const graphSquares = document.querySelectorAll('.graph-square');

  graphSquares.forEach(square => {
    square.addEventListener('click', function() {
      const boardId = this.getAttribute('data-board-id');
      if (boardId) {
        window.location.href = `/boards/${boardId}`;
      }
    });
  });
});
