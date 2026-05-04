$(document).ready(function () {
    $(".sideBarli").removeClass("activeLi");
    $(".registrationRequestsSideA").addClass("activeLi");

    function initTable(status) {
        const selector = `#registrationRequestsTable-${status}`;
        if ($.fn.dataTable.isDataTable(selector)) {
            return;
        }

        $(selector).DataTable({
            processing: true,
            serverSide: true,
            serverMethod: "post",
            aaSorting: [[9, "desc"]],
            columnDefs: [{ targets: [10], orderable: false }],
            ajax: {
                url: `${domainUrl}registrationRequestList`,
                data: function (data) {
                    data.status = status;
                },
                error: (error) => console.log(error),
            },
        });
    }

    ["pending", "approved", "rejected", "cancelled"].forEach(initTable);

    $(document).on("click", ".registration-view", function (e) {
        e.preventDefault();
        const id = $(this).attr("rel");
        $.get(`${domainUrl}registrationRequestDetail/${id}`, function (response) {
            if (!response.status) {
                iziToast.show({ title: "Oops", message: response.message, color: "red", position: toastPosition, transitionIn: "fadeInUp", transitionOut: "fadeOutDown", timeout: 2500 });
                return;
            }

            const data = response.data;
            $("#rr-name").text(data.full_name || "-");
            $("#rr-role").text((data.role_type || "-").toString().charAt(0).toUpperCase() + (data.role_type || "-").toString().slice(1));
            $("#rr-registration").text(data.registration_number || "-");
            $("#rr-department").text(data.department || "-");
            $("#rr-batch").text(data.batch_duration || "-");
            $("#rr-campus").text(data.campus || "COMSATS University Islamabad");
            $("#rr-email").text(data.email || data.identity || "-");
            $("#rr-phone").text(data.phone_number || "-");
            $("#rr-gender").text(data.gender || "-");
            $("#rr-status").text((data.approval_status || "approved").toString().charAt(0).toUpperCase() + (data.approval_status || "approved").toString().slice(1));
            $("#rr-submitted").text(data.created_at || "-");
            $("#rr-reason").text(data.rejected_reason || "-");
            $("#registrationRequestDetailModal").modal("show");
        });
    });

    function refreshTables() {
        ["pending", "approved", "rejected", "cancelled"].forEach((status) => {
            const selector = `#registrationRequestsTable-${status}`;
            if ($.fn.dataTable.isDataTable(selector)) {
                $(selector).DataTable().ajax.reload(null, false);
            }
        });
    }

    $(document).on("click", ".registration-approve", function (e) {
        e.preventDefault();
        const id = $(this).attr("rel");
        swal({ title: "Approve this request?", icon: "success", buttons: ["Cancel", "Approve"] }).then((confirm) => {
            if (!confirm) return;
            $.post(`${domainUrl}approveRegistrationRequest/${id}`, {}, function (response) {
                if (response.status) {
                    iziToast.show({ title: "Approved", message: response.message, color: "green", position: toastPosition, transitionIn: "fadeInUp", transitionOut: "fadeOutDown", timeout: 2500 });
                    refreshTables();
                } else {
                    iziToast.show({ title: "Oops", message: response.message, color: "red", position: toastPosition, transitionIn: "fadeInUp", transitionOut: "fadeOutDown", timeout: 2500 });
                }
            });
        });
    });

    $(document).on("click", ".registration-reject", function (e) {
        e.preventDefault();
        const id = $(this).attr("rel");
        const reason = window.prompt("Enter rejection reason:");
        if (!reason) return;
        swal({ title: "Reject this request?", icon: "error", buttons: ["Cancel", "Reject"] }).then((confirm) => {
            if (!confirm) return;
            $.post(`${domainUrl}rejectRegistrationRequest/${id}`, { rejected_reason: reason }, function (response) {
                if (response.status) {
                    iziToast.show({ title: "Rejected", message: response.message, color: "green", position: toastPosition, transitionIn: "fadeInUp", transitionOut: "fadeOutDown", timeout: 2500 });
                    refreshTables();
                } else {
                    iziToast.show({ title: "Oops", message: response.message, color: "red", position: toastPosition, transitionIn: "fadeInUp", transitionOut: "fadeOutDown", timeout: 2500 });
                }
            });
        });
    });

    $(document).on("click", ".registration-cancel", function (e) {
        e.preventDefault();
        const id = $(this).attr("rel");
        swal({ title: "Cancel this request?", icon: "warning", buttons: ["Cancel", "Cancel Request"] }).then((confirm) => {
            if (!confirm) return;
            $.post(`${domainUrl}cancelRegistrationRequest/${id}`, {}, function (response) {
                if (response.status) {
                    iziToast.show({ title: "Cancelled", message: response.message, color: "green", position: toastPosition, transitionIn: "fadeInUp", transitionOut: "fadeOutDown", timeout: 2500 });
                    refreshTables();
                } else {
                    iziToast.show({ title: "Oops", message: response.message, color: "red", position: toastPosition, transitionIn: "fadeInUp", transitionOut: "fadeOutDown", timeout: 2500 });
                }
            });
        });
    });
});