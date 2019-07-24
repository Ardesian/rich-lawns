$(".ctr-service_addresses.act-show").ready(function() {
  var duplicateOtherRow = function() {
    var template = document.querySelector("#extra-jobs-template")
    var content = document.importNode(template.content, true)
    $(".extra-jobs").append(content)
  }
  duplicateOtherRow()

  $(".extra-jobs").keypress(function() {
    var empty = $(".extra-jobs").find(".other-field").filter(function() { return this.value == "" })
    if (empty.length == 0) { duplicateOtherRow() }
  })
})
