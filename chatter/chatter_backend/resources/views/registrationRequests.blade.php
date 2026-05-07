@extends('include.app')
@section('header')
<script src="{{ asset('asset/script/registrationRequests.js') }}"></script>
@endsection

@section('content')
<section class="section">
    <div class="row mb-3">
        <div class="col-md-3 mb-3">
            <div class="dashboard-blog">
                <div class="dashboard-blog-content-top">
                    <p>{{ $pendingCount }}</p>
                    <div class="card-icon"><i data-feather="clock"></i></div>
                </div>
                <div class="dashboard-blog-content"><h5 class="fw-normal">Pending Requests</h5></div>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="dashboard-blog">
                <div class="dashboard-blog-content-top">
                    <p>{{ $approvedCount }}</p>
                    <div class="card-icon"><i data-feather="check-circle"></i></div>
                </div>
                <div class="dashboard-blog-content"><h5 class="fw-normal">Approved Users</h5></div>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="dashboard-blog">
                <div class="dashboard-blog-content-top">
                    <p>{{ $rejectedCount }}</p>
                    <div class="card-icon"><i data-feather="x-circle"></i></div>
                </div>
                <div class="dashboard-blog-content"><h5 class="fw-normal">Rejected Requests</h5></div>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="dashboard-blog">
                <div class="dashboard-blog-content-top">
                    <p>{{ $cancelledCount }}</p>
                    <div class="card-icon"><i data-feather="slash"></i></div>
                </div>
                <div class="dashboard-blog-content"><h5 class="fw-normal">Cancelled Requests</h5></div>
            </div>
        </div>
    </div>

    <nav class="card-tab">
        <div class="nav nav-tabs" id="nav-tab" role="tablist">
            <button class="nav-link active" id="nav-pending-tab" data-bs-toggle="tab" data-bs-target="#nav-pending" type="button" role="tab">Pending Requests</button>
            <button class="nav-link" id="nav-approved-tab" data-bs-toggle="tab" data-bs-target="#nav-approved" type="button" role="tab">Approved Users</button>
            <button class="nav-link" id="nav-rejected-tab" data-bs-toggle="tab" data-bs-target="#nav-rejected" type="button" role="tab">Rejected Requests</button>
            <button class="nav-link" id="nav-cancelled-tab" data-bs-toggle="tab" data-bs-target="#nav-cancelled" type="button" role="tab">Cancelled Requests</button>
        </div>
    </nav>

    <div class="tab-content" id="nav-tabContent">
        @foreach (['pending' => 'Pending Requests', 'approved' => 'Approved Users', 'rejected' => 'Rejected Requests', 'cancelled' => 'Cancelled Requests'] as $status => $title)
        <div class="tab-pane {{ $status === 'pending' ? 'show active' : '' }}" id="nav-{{ $status }}" role="tabpanel">
            <div class="card">
                <div class="card-header">
                    <div class="page-title w-100">
                        <div class="d-flex align-items-center justify-content-between">
                            <h4 class="mb-0 fw-normal d-flex align-items-center">{{ $title }}</h4>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <table class="table table-striped w-100 registration-requests-table" id="registrationRequestsTable-{{ $status }}" data-status="{{ $status }}">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Role</th>
                                <th>Registration Number</th>
                                <th>Department</th>
                                <th>Batch Duration</th>
                                <th>Campus</th>
                                <th>Email</th>
                                <th>Phone Number</th>
                                <th>Gender</th>
                                <th>Submitted At</th>
                                <th style="text-align: right; width: 280px;">Action</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
        @endforeach
    </div>
</section>

<div class="modal fade" id="registrationRequestDetailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-normal">Registration Request Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row g-3">
                    <div class="col-md-6"><strong>Name:</strong> <span id="rr-name"></span></div>
                    <div class="col-md-6"><strong>Role:</strong> <span id="rr-role"></span></div>
                    <div class="col-md-6"><strong>Registration Number:</strong> <span id="rr-registration"></span></div>
                    <div class="col-md-6"><strong>Department:</strong> <span id="rr-department"></span></div>
                    <div class="col-md-6"><strong>Batch Duration:</strong> <span id="rr-batch"></span></div>
                    <div class="col-md-6"><strong>Campus:</strong> <span id="rr-campus"></span></div>
                    <div class="col-md-6"><strong>Email:</strong> <span id="rr-email"></span></div>
                    <div class="col-md-6"><strong>Phone Number:</strong> <span id="rr-phone"></span></div>
                    <div class="col-md-6"><strong>Gender:</strong> <span id="rr-gender"></span></div>
                    <div class="col-md-6"><strong>Status:</strong> <span id="rr-status"></span></div>
                    <div class="col-md-6"><strong>Submitted At:</strong> <span id="rr-submitted"></span></div>
                    <div class="col-md-12"><strong>Rejected Reason:</strong> <span id="rr-reason"></span></div>
                    <div class="col-md-12">
                        <strong>University Card / ID Card:</strong>
                        <div class="mt-2" id="rr-card-wrap">
                            <div class="d-flex flex-column flex-md-row align-items-start gap-3">
                                <img id="rr-card-image" src="" alt="University card" style="display:none; max-width: 100%; width: 260px; height: auto; border-radius: 12px; border: 1px solid rgba(0,0,0,0.12);" />
                                <div class="d-flex flex-column gap-2">
                                    <a id="rr-card-open" href="#" target="_blank" rel="noopener" class="btn btn-primary btn-sm" style="display:none; width: fit-content;">Open Full Image</a>
                                    <span id="rr-card-empty" class="text-muted" style="display:none;">No card uploaded</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection