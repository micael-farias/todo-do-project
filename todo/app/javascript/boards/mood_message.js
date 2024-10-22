document.addEventListener('DOMContentLoaded', function() {
    const generateBoardButton = document.getElementById('generate-board-button');
  
    if (generateBoardButton) {
      generateBoardButton.addEventListener('click', function(event) {
        event.preventDefault();
  
        const messageSection = document.getElementById('mood-message-section');
        const messageAboveSection = document.getElementById('mood-message-above-section');
        const selectedMoodsText = document.getElementById('selected-mood-text');
        const selectedMoodItem = document.querySelector('.mood-item.selected');
        const selectedMoodIdField = document.getElementById('selected_mood_id');
        const selectedMoodId = selectedMoodIdField.value;
        const selectedMoodName = selectedMoodItem ? selectedMoodItem.querySelector('.mood-name').innerText : '';
  
        if (!selectedMoodId) {
          alert('Por favor, selecione pelo menos um humor antes de gerar o board.');
          return;
        }
  
        selectedMoodsText.innerText = "Sua Análise de Humor: " + selectedMoodName;
        messageAboveSection.scrollIntoView({ behavior: 'smooth' });
  
        fetch('/update_user_moods', {
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
            if (data.theme_mood) {
              document.getElementById('mood-image').setAttribute('src', data.theme_mood.image_url);
              document.getElementById('mood-message').innerText = data.theme_mood.message;
            }
            selectedMoodsText.innerText = "Sua Análise de Humor: " + selectedMoodName;
            messageSection.style.display = 'block';
          } else {
            alert('Erro ao atualizar humor: ' + data.error);
          }
        })
        .catch(error => console.error('Erro:', error));
      });
    }
  });
  