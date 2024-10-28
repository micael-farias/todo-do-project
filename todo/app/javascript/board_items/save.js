import { updateColumn } from "./edit";
import { createColumn } from "./new";

export function consolidateColumnEdit(input) {
  var newName = input.val().trim();
  if (!validateColumnName(newName)) return;

  var columnId = input.closest('.column').data('board-item-id');
  var boardId = $('#kanban-board').data('board-id');

  if (columnId === undefined) {
    createColumn(input.closest('form'), newName);
  } else {
    updateColumn(columnId, newName, boardId, input);
  }
}

function validateColumnName(name) {
  if (name === "") {
    return false;
  }
  return true;
}

