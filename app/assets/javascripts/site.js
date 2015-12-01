$(document).ready(function(){
  nav_loc =  $('nav').offset().top

  $(window).scroll(function () {
      if ( nav_loc - $(window).scrollTop() < 0 ){
        $('nav').addClass('top-bar-fixed')
        $('nav .site-header-text').show()
      }

      else {
        $('nav').removeClass('top-bar-fixed');
        $('nav .site-header-text').hide();
      }
  });

})
