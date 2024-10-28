$(document).ready(function () {
    var moodItems = $('.mood-item');
    var selectedMoodIdField = $('#selected_mood_id');
    var selectedMoodId = null;

    moodItems.each(function () {
        var moodId = $(this).data('mood-id');
        if ($(this).hasClass('selected')) {
            selectedMoodId = moodId;
        }
    });

    selectedMoodIdField.val(selectedMoodId || '');

    moodItems.each(function () {
        $(this).on('click', function () {
            var moodId = $(this).data('mood-id');

            if ($(this).hasClass('selected')) {
                $(this).removeClass('selected');
                selectedMoodId = null;
            } else {
                moodItems.removeClass('selected');
                $(this).addClass('selected');
                selectedMoodId = moodId;
            }

            selectedMoodIdField.val(selectedMoodId || '');
        });
    });

    var generateBoardButton = $('#generate-board-button');

    generateBoardButton.on('click', function (event) {
        event.preventDefault();

        var messageAboveSection = $('#mood-message-above-section');
        var selectedMoodsText = $('#selected-mood-text');

        var selectedMoodItem = $('.mood-item.selected');
        console.log(selectedMoodItem);
        var selectedMoodName = selectedMoodItem.length ? selectedMoodItem.find('.mood-name').text() : '';

        if (!selectedMoodId) {
            alert('Por favor, selecione pelo menos um humor antes de gerar o board.');
            return;
        }

        selectedMoodsText.text("Sua Análise de Humor: " + selectedMoodName);

        messageAboveSection.get(0).scrollIntoView({ behavior: 'smooth' });

        $.ajax({
            url: '/update_user_moods',
            method: 'POST',
            contentType: 'application/json',
            headers: {
                'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
            },
            data: JSON.stringify({ mood_id: selectedMoodId }),
            success: function (data) {
                if (data.success) {
                    console.log(data);

                    if (data.theme_mood) {
                        $('#mood-image').attr('src', data.theme_mood.image_url);

                        $('#mood-message').text(data.theme_mood.message);
                        if ($('#navbar-mood').length) {
                            $('#navbar-mood').text("Humor de hoje: " + data.theme_mood.name);
                        }
                    }

                    selectedMoodsText.text("Sua Análise de Humor: " + selectedMoodName);

                    $('#mood-message-section').show();

                } else {
                    alert('Erro ao atualizar humor: ' + data.error);
                }
            },
            error: function (error) {
                console.error('Erro:', error);
            }
        });

    });

    var editMoodButton = $('#edit-mood-button');

    editMoodButton.on('click', function () {
        var moodSelection = $('#mood-selection');
        var messageSection = $('#mood-message-section');

        moodSelection.css('display', 'flex');
        messageSection.css('display', 'block');

        setTimeout(function () {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }, 100);
    });

});
