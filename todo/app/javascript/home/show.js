$(document).ready(function () {
  var $searchInput = $('#searchInput');
  var $searchResults = $('#searchResults');

  function debounce(func, wait) {
    var timeout;
    return function () {
      var context = this, args = arguments;
      clearTimeout(timeout);
      timeout = setTimeout(function () {
        func.apply(context, args);
      }, wait);
    };
  }

  function performSearch() {
    var query = $searchInput.val().trim();

    if (query.length === 0) {
      $searchResults.empty().hide();
      return;
    }

    $.ajax({
      url: '/cards/search',
      method: 'GET',
      data: { query: query },
      dataType: 'json',
      success: function (data) {
        $searchResults.empty();

        if (data.length > 0) {
          $.each(data, function (index, card) {
            var listItem = $('<li class="list-group-item list-group-item-action"></li>');
            var linkHref = '/boards/' + card.board_id + '?highlight_card=' + card.id;
            var link = $('<a></a>', {
              href: linkHref,
              class: 'text-decoration-none list-item d-block w-100' // Adiciona d-block e w-100
            }).text(card.title);

            listItem.append(link);
            $searchResults.append(listItem);
          });
          $searchResults.show();
        } else {
          var noResult = $('<li class="list-group-item">Nenhum card encontrado.</li>');
          $searchResults.append(noResult).show();
        }
      },
      error: function (xhr, status, error) {
        console.error('Erro na busca:', error);
        $searchResults.empty().hide();
      }
    });
  }

  $searchInput.on('input', debounce(performSearch, 300));

  $searchResults.on('click', 'li.list-group-item a', function (e) {
    $searchResults.empty().hide();
  });

  $(document).on('click', function (e) {
    if (!$(e.target).closest('#searchForm').length) {
      $searchResults.empty().hide();
    }
  });
});