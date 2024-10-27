import { openForm } from "./open-form";

export function becomeCardClickable(card) {
    $(".card-content").on("click", function(e) {
        e.stopPropagation()
        var cardId = card.data('card-id');        
        openForm(card, cardId);        
    });
}