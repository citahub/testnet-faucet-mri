// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/


$(document).on("turbolinks:load", () => {
  $("#captcha img").click((e) => {
    let timestamp = new Date().getTime();
    let src = $(e.target).attr("src");
    $(e.target).attr('src', src + '?' +timestamp );
  });
});
