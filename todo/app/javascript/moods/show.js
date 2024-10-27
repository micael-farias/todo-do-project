$(document).ready(function() {
    // Seleção de Humores
    var moodItems = $('.mood-item');
    var selectedMoodIdField = $('#selected_mood_id');
    var selectedMoodId = null;

    // Inicializar a seleção com o humor ativo, se existir
    moodItems.each(function() {
        var moodId = $(this).data('mood-id');
        if ($(this).hasClass('selected')) {
            selectedMoodId = moodId;
        }
    });

    selectedMoodIdField.val(selectedMoodId || '');

    // Manipulação das caixas de humor para seleção única
    moodItems.each(function() {
        $(this).on('click', function() {
            var moodId = $(this).data('mood-id');

            if ($(this).hasClass('selected')) {
                // Se o humor já está selecionado, desmarcar
                $(this).removeClass('selected');
                selectedMoodId = null;
            } else {
                // Desmarcar todos os outros humores
                moodItems.removeClass('selected');
                // Marcar o humor clicado
                $(this).addClass('selected');
                selectedMoodId = moodId;
            }

            selectedMoodIdField.val(selectedMoodId || '');
        });
    });

    // Manipulação do botão "Gerar Board"
    var generateBoardButton = $('#generate-board-button');

    generateBoardButton.on('click', function(event) {
        event.preventDefault(); // Evita a submissão do formulário imediatamente

        var messageAboveSection = $('#mood-message-above-section');
        var selectedMoodsText = $('#selected-mood-text');

        // Obter o nome do humor selecionado
        var selectedMoodItem = $('.mood-item.selected');
        console.log(selectedMoodItem);
        var selectedMoodName = selectedMoodItem.length ? selectedMoodItem.find('.mood-name').text() : '';

        if (!selectedMoodId) {
            alert('Por favor, selecione pelo menos um humor antes de gerar o board.');
            return;
        }

        selectedMoodsText.text("Sua Análise de Humor: " + selectedMoodName);

        messageAboveSection.get(0).scrollIntoView({ behavior: 'smooth' });

        // Atualizar os humores ativos via AJAX
        $.ajax({
            url: '/update_user_moods', // Atualize a rota conforme necessário
            method: 'POST',
            contentType: 'application/json',
            headers: {
                'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
            },
            data: JSON.stringify({ mood_id: selectedMoodId }),
            success: function(data) {
                if (data.success) {
                    console.log(data);

                    // Verifica se os dados de theme_mood foram retornados
                    if (data.theme_mood) {
                        // Atualiza a imagem de humor
                        $('#mood-image').attr('src', data.theme_mood.image_url);

                        // Atualiza a mensagem de humor
                        $('#mood-message').text(data.theme_mood.message);
                                console.log($('#navbar-mood'))
                        if ($('#navbar-mood').length) {
                            $('#navbar-mood').text("Humor de hoje: " + data.theme_mood.name);
                        }
                    }

                    // Atualiza o texto da análise de humor
                    selectedMoodsText.text("Sua Análise de Humor: " + selectedMoodName);

                    // Mostra a seção de mensagem de humor
                    $('#mood-message-section').show();

                } else {
                    alert('Erro ao atualizar humor: ' + data.error);
                }
            },
            error: function(error) {
                console.error('Erro:', error);
            }
        });

    });

    // Manipulação do botão "Editar Humor"
    var editMoodButton = $('#edit-mood-button');

    editMoodButton.on('click', function() {
        var moodSelection = $('#mood-selection');
        var messageSection = $('#mood-message-section');

        // Mostrar a seleção de humores imediatamente
        moodSelection.css('display', 'flex');
        messageSection.css('display', 'block');

        // Adicionar um pequeno delay para garantir que a visibilidade foi aplicada antes de rolar para o topo
        setTimeout(function() {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }, 100); // Ajuste o tempo conforme necessário (100ms é geralmente suficiente)
    });

});
