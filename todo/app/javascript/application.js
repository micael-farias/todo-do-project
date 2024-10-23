//= require chartkick
//= require Chart.bundle


// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "popper"
import "bootstrap"
import Sortable from 'sortablejs';
import "chartkick/chart.js"
import "./custom/card_edit"
import 'jquery';
import './boards/ajax_setup';
import './boards/board_form';
import './boards/cards_graph';
import './boards/mood_selection';
import './boards/mood_message';
import './boards/mood_update';

document.addEventListener('turbo:load', () => {
  const lists = document.querySelectorAll('.cards');

  lists.forEach((list) => {
    new Sortable(list, {
      group: {
        name: 'shared', // Permite que os cartões sejam movidos entre listas diferentes
        pull: true,     // Habilita puxar o cartão de uma lista
        put: true       // Habilita colocar o cartão em outra lista
      },
      animation: 150,   // Animação de arrastar e soltar
      onEnd: (event) => {
        console.log('Card moved from list', event.from.dataset.listId, 'to list', event.to.dataset.listId);
        console.log('New card position:', event.newIndex);
        // Aqui você pode adicionar a lógica para salvar a nova posição via AJAX mais tarde
      }
    });
  });
});

