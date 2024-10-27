
$(document).ready(function() {

    $('#add-board-button').on('click', function(e) {
      e.preventDefault();
      var $this = $(this);
      var $form = $('.new-board-form');
      
      $this.hide();
      $form.show().insertAfter($this);
      $form.find('.board-title-input').focus();
    });

    $(document).on('click', function(e) {
      var $target = $(e.target);
      if (!$target.closest('.new-board-form').length && !$target.closest('#add-board-button').length) {
        $('.new-board-form').hide();
        $('#add-board-button').show();
      }
    });
    
    $(document).on('keypress', '.board-title-input', function(e) {
        if (e.which == 13) { // Código da tecla Enter
          e.preventDefault();
          var $form = $(this).closest('form');
  
          $.ajax({
            url: $form.attr('action'),
            method: 'POST',
            data: $form.serialize(),
            dataType: 'json',
            success: function(response) {
              if (response.success) {
                var newBoardCard = $(response.rendered_board).hide();
                    
                $('#add-board-button').after(newBoardCard);
                newBoardCard.fadeIn(300);

                $form.find('.board-title-input').val('');
                $form.closest('.new-board-form').hide();
                $('#add-board-button').show();

              } else {
                alert('Erro ao criar o board: ' + response.message);
              }
            },
            error: function() {
              alert('Erro ao criar o board. Por favor, tente novamente.');
            }
          });
        }
   });

})