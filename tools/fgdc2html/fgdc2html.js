$(document).ready( function () {
    $("h3").on("click", function() {
        $(this).toggleClass('expanded');
        $(this).next("section").toggle();
    }).next("section").toggle();
});