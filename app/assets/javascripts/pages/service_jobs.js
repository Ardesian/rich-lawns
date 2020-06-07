$(".ctr-service_jobs").ready(function() {
  var duplicateTemplateRow = function() {
    var template = document.querySelector("#extra-jobs-template")
    if (!template) { return }
    var content = document.importNode(template.content, true)
    $(".extra-jobs").append(content)
  }
  duplicateTemplateRow()

  $(document).on("keyup", ".item-fields", function() {
    var isEmpty = $(".extra-jobs").find(".other-field").filter(function() { return this.value == "" })
    if (isEmpty.length == 0) { duplicateTemplateRow() }

    var invoice_total = 0

    $(".item-fields").each(function() {
      var unitField = $(this).find(".unit-field")
      var unitCostField = $(this).find(".cost-field")
      var totalField = $(this).find(".total-row")

      var unitCount = parseInt(unitField.val())
      var unitCost = parseInt(unitCostField.val())
      var total = unitCount * unitCost

      if (isNaN(total)) {
        totalField.val("--")
      } else {
        invoice_total += total
        totalField.val(total)
      }
    })

    $("#invoice-total").val(invoice_total)
  })

})
