$.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
});

var scrollPosition = sessionStorage.getItem('scrollPosition');
  
if (scrollPosition) {
  $(window).scrollTop(scrollPosition);
  sessionStorage.removeItem('scrollPosition');
}