document.addEventListener("DOMContentLoaded", function () {
  const addMoreBtn = document.getElementById("addMoreBtn");
  addMoreBtn.addEventListener("click", function (event) {
    event.preventDefault();
    const form = document.querySelector(".report-form");
    const formFieldsWrapper = form.querySelector(".form-fields-wrapper");
    const currentIndex = parseInt(form.querySelector(".index-field").value);
    const newIndex = currentIndex + 1;

    const newFormFieldsWrapper = formFieldsWrapper.cloneNode(true);

    // Update the index value
    const newIndexField = newFormFieldsWrapper.querySelector(".index-field");
    if (newIndexField) {
      newIndexField.value = newIndex;
    }

    // Reset field values for the new form fields
    const fieldsToReset = newFormFieldsWrapper.querySelectorAll(
      "input, select, textarea"
    );
    fieldsToReset.forEach((field) => {
      if (field.type !== "submit") {
        field.value = ""; // Reset field value
        field.removeAttribute("id"); // Remove ID attribute to prevent duplicate IDs
      }
    });

    // Append the cloned form fields inside the form-fields-wrapper div
    formFieldsWrapper.appendChild(newFormFieldsWrapper);
  });
});
