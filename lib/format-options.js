(function() {
  var bad_statuses, bad_types, critical_priority, high_priority, low_priority, med_priority;

  bad_statuses = ["QA Failed"];

  bad_types = ["Production Issue", "Bug", "Defect"];

  low_priority = ["Low"];

  med_priority = ["Medium"];

  high_priority = ["High"];

  critical_priority = ["Blocker", "Critical"];

  module.exports = {
    bad_statuses: bad_statuses,
    bad_types: bad_types,
    low_priority: low_priority,
    med_priority: med_priority,
    high_priority: high_priority,
    critical_priority: critical_priority
  };

}).call(this);
