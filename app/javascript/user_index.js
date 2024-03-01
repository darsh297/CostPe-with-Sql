// A $( document ).ready() block.
$(document).ready(function () {
  alert("hello ");
  // Automatically submit the form when a company is selected
  const companySelect = document.getElementById("company_select");
  companySelect.addEventListener("change", function () {
    document.getElementById("company_filter_form").submit();
  });
});
