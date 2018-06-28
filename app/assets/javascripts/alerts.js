$(document).on('turbolinks:load', function() {

  $(".alert").delay(4000).animate({ opacity: 0 }, 3000, function(){
    $(".main-body").animate({marginTop: '-=72px'}, 1500).css("margin-top", "0px");
  });

});
