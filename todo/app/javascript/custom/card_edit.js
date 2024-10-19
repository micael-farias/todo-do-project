
document.addEventListener('turbolinks:load', function() {
    // Abrir modal ao clicar no card
    document.querySelectorAll('.card').forEach(function(card) {
      card.addEventListener('click', function(e) {
        if (!e.target.closest('.card-actions')) {
          var cardId = this.dataset.cardId;
          var boardId = document.querySelector('#kanban-board').dataset.boardId;
          var boardItemId = this.closest('.column').dataset.boardItemId;
          openEditCardModal(cardId, boardId, boardItemId);
        }
      });
    });
  
    // Função para abrir a modal e carregar os dados do card
    function openEditCardModal(cardId, boardId, boardItemId) {
      var modal = new bootstrap.Modal(document.getElementById('editCardModal'));
      var form = document.getElementById('edit-card-form');
  
      // Atualizar a URL do formulário
      form.action = `/boards/${boardId}/board_items/${boardItemId}/cards/${cardId}`;
  
      // Carregar os dados do card
      fetch(`/boards/${boardId}/board_items/${boardItemId}/cards/${cardId}/edit`)
        .then(response => response.json())
        .then(data => {
          form.querySelector('#card_title').value = data.title;
          form.querySelector('#card_description').value = data.description;
          form.querySelector('#card_mood_id').value = data.mood_id || '';
          form.querySelector('#card_due_date').value = data.due_date || '';
          form.querySelector('#card_priority').value = data.priority || '';
          modal.show();
        })
        .catch(error => console.error('Erro ao carregar dados do card:', error));
    }
  
    // Enviar formulário de edição via AJAX
    document.getElementById('edit-card-form').addEventListener('submit', function(e) {
      e.preventDefault();
      var form = this;
      var formData = new FormData(form);
  
      fetch(form.action, {
        method: 'PATCH',
        body: formData,
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        }
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          // Atualizar o card na interface
          var card = document.querySelector(`.card[data-card-id="${data.card.id}"]`);
          card.querySelector('.card-content').innerHTML = `
            ${data.card.title}
            <p>${data.card.description || ''}</p>
            <p><strong>Humor:</strong> ${data.card.mood ? data.card.mood.name : 'Não definido'}</p>
            ${data.card.due_date ? `<p><strong>Data de Vencimento:</strong> ${new Date(data.card.due_date).toLocaleDateString()}</p>` : ''}
            <p><strong>Prioridade:</strong> ${['Baixa', 'Média', 'Alta'][data.card.priority] || 'Não definida'}</p>
          `;
  
          // Fechar a modal
          bootstrap.Modal.getInstance(document.getElementById('editCardModal')).hide();
        } else {
          alert('Erro ao atualizar o card: ' + data.message);
        }
      })
      .catch(error => {
        console.error('Erro ao atualizar o card:', error);
        alert('Erro ao atualizar o card. Por favor, tente novamente.');
      });
    });
  });