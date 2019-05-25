$(function(){

  $("script[type='text/coffee']").each(function(idx, elem) {
    src = $(elem).data("src")
    $.get(src, function(coffee){
      // console.log(coffee)
      eval(CoffeeScript.compile(coffee))

    })
  })

})
