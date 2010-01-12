$( function() {
  function searchPosts(query) {
    var r = new RegExp(query, 'i');

    $('#posts li').hide();

    $('#posts li span').each( function(index, element) {
      if ( isElementMatch(element, r) ) {
        $(element.parentNode).show();
      }
      
    });
  }

  function isElementMatch(element, exp) {
    return exp.test(element.innerHTML);
  }

  $('#published').click(function() {
    if ( this.checked ) {
      console.log('Pickles');
    }
  });

  $('#posts').before('<div id="search"><label for="query">Search: </label><input type="text" name="query" id="query"/></div>');
  $('#query').keyup(function() { 
    searchPosts(this.value);
  });
})
