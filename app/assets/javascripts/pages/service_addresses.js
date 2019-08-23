$(".ctr-service_addresses.act-index").ready(function() {
  $(".search-service-addresses").keyup(function() {
    var q = $(this).val()
    search(q)
  })
  // btn auto-fill-service-address

  var filterCards = function() {
    sortCardsByRelevance()
    $(".address-card").removeClass("hidden")
    $(".address-card[data-relevance=0]").addClass("hidden")
  }

  var sortCardsByRelevance = function() {

  }

  var markNestedRelevance = function(search_string, ele) {
    $(ele).find(".searchable").each(function() {
      var $searchable = $(this)
      $searchable.attr("data-relevance", relevanceOfString(search_string, $searchable.text()))
    })
  }

  var getHighestRelevance = function(spans) {
    var relevances = $(spans).map(function(idx, span) {
      return parseInt($(span).attr("data-relevance") || 0)
    })
    return Math.max.apply(null, relevances)
    // return $(spans).reduce(function(max, span, idx, allSpans) {
    //   var spanRelevance = parseInt(span.attr("data-relevance") || 0)
    //   return max < spanRelevance ? spanRelevance : max
    // }, 0)
  }

  var relevanceOfString = function(query, str) {
    if (query.replace(/\s/gi, "").length == 0) { return 1 }
    if (str.replace(/\s/gi, "").length == 0) { return 0 }

    var checks = str.split(" "), relevance = 0

    checks.forEach(function(check) {
      if (check.toLowerCase().indexOf(query.toLowerCase()) >= 0) { relevance += 1 }
    })

    return relevance
    // var optionText = ele.text.toLowerCase(), optionVal = ele.value.toLowerCase(), string_valid = true
    // if (foundCount < dropdownMaxValues) {
    //   $(search_string.split('')).each(function() {
    //     var char_index = optionText.indexOf(this)
    //     if (char_index < 0) {
    //       string_valid = false
    //     } else {
    //       optionText = optionText.substr(char_index + 1)
    //     }
    //   })
    //   if (string_valid) {
    //     foundCount += 1
    //     foundOptions.push(ele)
    //   }
    // }
  }

  var search = function(search_string)  {
    var allCards = $(".address-card")
    var foundOptions = [], foundCount = 0
    // address-card data lastService
    // searchable

    search_string = search_string.toLowerCase()
    $(allCards).each(function(idx, ele) {
      markNestedRelevance(search_string, ele)
      var mostRelevant = getHighestRelevance($(ele).find(".searchable"))
      $(ele).attr("data-relevance", mostRelevant)
    })
    filterCards()
  }
})
