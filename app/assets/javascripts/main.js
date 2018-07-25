$(document).on("turbolinks:load", function() {

  //Show form for leaving new comment
  $("#create-new-comment-btn").click(function() {
    $(".new-comment-thank-you").hide();
    $("#new_comment").slideDown("slow");
    $("#create-new-comment-btn").prop("disabled", true);
  });

});
