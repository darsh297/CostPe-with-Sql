module ApplicationHelper
def display_errors(form, field)
  if form.object.present? && form.object.errors[field].any?
    content_tag(:div, form.object.errors[field].to_sentence, class: "error-message")
  end
end

end
