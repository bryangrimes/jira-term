(function() {
  var bad_statuses, bad_types, critical_priority, good_statuses, high_priority, low_priority, med_priority;

  bad_statuses = ["QA Failed", "Backlog"];

  good_statuses = ["QA Passed", "Closed", "Task Complete"];

  bad_types = ["Production Issue", "Bug"];

  low_priority = ["Low"];

  med_priority = ["Medium"];

  high_priority = ["High"];

  critical_priority = ["Blocker", "Critical"];

}).call(this);
