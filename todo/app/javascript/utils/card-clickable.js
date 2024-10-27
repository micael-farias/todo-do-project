import { openForm } from "./open-form";

export function becomeCardClickable(card) {
    $(".card-content").on("click", function(e) {
        e.stopPropagation()
        openForm(card);        
    });
}