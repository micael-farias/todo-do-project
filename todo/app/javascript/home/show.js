$(document).ready(function() {
    var $searchInput = $('#searchInput');
    var $searchResults = $('#searchResults');

    // Função de debounce para limitar a frequência das requisições AJAX
    function debounce(func, wait) {
      var timeout;
      return function() {
        var context = this, args = arguments;
        clearTimeout(timeout);
        timeout = setTimeout(function() {
          func.apply(context, args);
        }, wait);
      };
    }

    // Função para realizar a busca via AJAX
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
        success: function(data) {
          $searchResults.empty();

          if (data.length > 0) {
            $.each(data, function(index, card) {
                var listItem = $('<li class="list-group-item list-group-item-action"></li>');
                var linkHref = '/boards/' + card.board_id + '?highlight_card=' + card.id;
                var link = $('<a></a>', {
                    href: linkHref,
                    class: 'text-decoration-none text-dark d-block'
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
        error: function(xhr, status, error) {
          console.error('Erro na busca:', error);
          $searchResults.empty().hide();
        }
      });
    }

    // Aplicar debounce na função de busca (300ms de espera)
    $searchInput.on('input', debounce(performSearch, 300));

    // Evento de clique nos resultados para navegação
    $searchResults.on('click', 'li.list-group-item a', function(e) {
      // A ação padrão do link irá redirecionar o usuário
      $searchResults.empty().hide();
    });

    // Esconder os resultados ao clicar fora do formulário de busca
    $(document).on('click', function(e) {
      if (!$(e.target).closest('#searchForm').length) {
        $searchResults.empty().hide();
      }
    });
  });