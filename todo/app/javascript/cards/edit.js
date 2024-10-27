import { addTag } from "../tags/add-tag";

$(document).ready(function() {

  function removeTag(tag, containerId, hiddenFieldId) {
    $(`#${containerId} .tag-badge[data-tag="${tag}"]`).remove();

    // Atualizar o campo hidden
    var currentTags = $(`#${hiddenFieldId}`).val().split(',');
    var updatedTags = currentTags.filter(function(t) {
      return t.trim().toLowerCase() !== tag.trim().toLowerCase();
    });
    $(`#${hiddenFieldId}`).val(updatedTags.join(','));
  }   

  $('#tag-input-new').on('keypress', function(e) {
    if (e.which == 13) { // Tecla Enter
      e.preventDefault();
      var tag = $(this).val();
      addTag(tag, 'tag-container-new', 'card_tags_new');
      $(this).val('');
    }
  });

  $('#tag-container-new').on('click', '.remove-tag', function() {
    var tag = $(this).parent().data('tag');
    removeTag(tag, 'tag-container-new', 'card_tags_new');
  });

  $('#tag-input-edit').on('keypress', function(e) {
    if (e.which == 13) { // Tecla Enter
      e.preventDefault();
      var tag = $(this).val();
      addTag(tag, 'tag-container-edit', 'card_tags_edit');
      $(this).val('');
    }
  });

  $('#tag-container-edit').on('click', '.remove-tag', function() {
    var tag = $(this).parent().data('tag');
    removeTag(tag, 'tag-container-edit', 'card_tags_edit');
  });

  $('#edit-card-form').on('submit', function(e) {
    e.preventDefault();
    var form = $(this);
    var formData = form.serialize();

    $.ajax({
      url: form.attr('action'),
      method: 'PATCH',
      data: formData,
      dataType: 'json',
      success: function(data) {
        console.log(data.card.mood);
        if (data.success) {
          sessionStorage.setItem('scrollPosition', $(window).scrollTop());
      
          var url = new URL(window.location.href);
          url.searchParams.delete('highlight_card'); // Substitua pelo nome do parâmetro a remover
      
          window.history.replaceState({}, document.title, url.pathname + url.search);
      
          location.reload();
      } else {
          alert('Erro ao atualizar o card: ' + data.message);
      }
      
      },
      error: function() {
        alert('Erro ao atualizar o card. Por favor, tente novamente.');
      }
    });
  });
  
})