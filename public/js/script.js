/* Author: Eric Koslow

*/

$(function() {
  changeLocation = function() {
    var l = location.hash.split('!/')[1] || '/';
    console.log(l);
    $("#main").fadeOut(function() {
      var self = this;
      $(self).empty();
      $.get('ajax/'+l, function(data) {
        $(self).html(data);
        bindA();
        bindNext();
      });
      $(self).fadeIn();
    }); 
  }
  bindA = function() {
    $('a').click(function(e) {
      if(location.pathname === '/') {
        location.hash = '!'+$(this).attr('href');
        return false;
      }
    });
  }
  bindNext = function() {
    $("#next").appear(function() {
      var self = this;
      $(self).fadeOut(function() {
        $.get('ajax'+$("#next a").attr('href'), function(data) {
          $(self).remove();
          $("#main").append(data);
          bindA();
        });
      });
    });
  }


  $(window).bind('hashchange', changeLocation);


  // MAIN LOOP
  bindA();
  bindNext();
  if(location.hash && location.hash !== '#!/') {
    changeLocation();
  }
});
