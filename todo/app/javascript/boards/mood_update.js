document.addEventListener('DOMContentLoaded', function() {
    const editMoodButton = document.getElementById('edit-mood-button');
    
    if (editMoodButton) {
      editMoodButton.addEventListener('click', function() {
        const moodSelection = document.getElementById('mood-selection');
        const messageSection = document.getElementById('mood-message-section');
        
        moodSelection.style.display = 'flex';
        messageSection.style.display = 'block';
  
        setTimeout(() => {
          window.scrollTo({ top: 0, behavior: 'smooth' });
        }, 100);
      });
    }
  
    const form = document.getElementById('daily-board-form');
    if (form) {
      form.addEventListener('submit', function(event) {
        event.preventDefault();
        const selectedMoodId = document.getElementById('selected_mood_id').value;
  
        if (!selectedMoodId) {
          alert('Por favor, selecione pelo menos um humor.');
          return;
        }
  
        fetch(form.action, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          },
          body: JSON.stringify({ mood_id: selectedMoodId })
        })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            console.log('Humor enviado com sucesso:', data);
          } else {
            alert('Erro ao enviar humor: ' + data.error);
          }
        })
        .catch(error => {
          console.error('Erro:', error);
        });
      });
    }
  });
  