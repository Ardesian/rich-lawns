$(document).ready(function() {
  window.Parsley.on('field:error', function() {
    $(this.$element).parents(".input-row").addClass("parsley-error")
  }).on('field:success', function() {
    $(this.$element).parents(".input-row").removeClass("parsley-error")
    $(".error-tooltip-wrapper").remove()
  })

  $(".input-row input").on("focus", function() {
    var $input = $(this), $wrapper = $input.parents(".input-row"), $container = $input.parents("form") || $input.parents(".content")

    var errors = $wrapper.find("ul.parsley-errors-list li")
    if (errors.length > 0) {
      var error_message = errors.first().text()
      $container.find(".error-tooltip-wrapper").remove()
      var tooltip = $("<div>", { class: "error-tooltip-wrapper" }).html($("<div>", { class: "error-tooltip" }).html($("<span>").text(error_message)))
      $wrapper.append(tooltip)

      tooltip.css({top: tooltip.outerHeight() + 20})
    } else {
      $container.find(".error-tooltip-wrapper").remove()
    }
  }).on("blur", function() {
    var $input = $(this), $container = $input.parents("form") || $input.parents(".content")
    $container.find(".error-tooltip-wrapper").remove()
  })
})
