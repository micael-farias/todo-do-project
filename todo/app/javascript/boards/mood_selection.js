document.addEventListener('DOMContentLoaded', function() {
    // Seleção de Humores
    const moodItems = document.querySelectorAll('.mood-item');
    const selectedMoodIdField = document.getElementById('selected_mood_id');
    let selectedMoodId = null;
  
    // Inicializar a seleção com o humor ativo, se existir
    moodItems.forEach(item => {
      const moodId = item.getAttribute('data-mood-id');
      if (item.classList.contains('selected')) {
        selectedMoodId = moodId;
      }
    });
    selectedMoodIdField.value = selectedMoodId || '';
  
    // Manipulação das caixas de humor para seleção única
    moodItems.forEach(item => {
      item.addEventListener('click', function() {
        const moodId = this.getAttribute('data-mood-id');
  
        if (this.classList.contains('selected')) {
          this.classList.remove('selected');
          selectedMoodId = null;
        } else {
          moodItems.forEach(i => i.classList.remove('selected'));
          this.classList.add('selected');
          selectedMoodId = moodId;
        }
  
        selectedMoodIdField.value = selectedMoodId || '';
      });
    });
  });
  