$(document).ready(function () {

    $('#avatar-upload').on('change', function () {
        var file = this.files[0];
        if (file) {
            var reader = new FileReader();
            reader.onload = function (e) {
                $('.avatar-image').attr('src', e.target.result);
            }
            reader.readAsDataURL(file);
        }
    });

    $('.mood-category-item').on('click', function () {
        $('.mood-category-item').removeClass('selected');
        $(this).addClass('selected');
        var selectedCategoryId = $(this).data('category-id');
        $('#selected_mood_category_id').val(selectedCategoryId);
    });

    $('.mood-item').on('click', function () {
        $('.mood-item').removeClass('selected');
        $(this).addClass('selected');
        var selectedMoodId = $(this).data('theme-mood-id');
        $('#selected_mood_id').val(selectedMoodId);
    });

});