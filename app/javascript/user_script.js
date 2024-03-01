document.addEventListener("DOMContentLoaded", function () {
  const roleSelect = document.getElementById("role-select");
  const designationDepartmentFields = document.getElementById(
    "designation-department-fields"
  );

  // Hide designation and department fields initially
  designationDepartmentFields.style.display = "none";

  roleSelect.addEventListener("change", function () {
    if (roleSelect.value === "2") {
      // If Company Admin is selected, hide designation and department fields
      designationDepartmentFields.style.display = "none";
    } else {
      // Otherwise, show designation and department fields
      designationDepartmentFields.style.display = "block";
    }
  });
});
