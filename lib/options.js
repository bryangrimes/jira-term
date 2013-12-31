(function() {
  var FormatOptions;

  FormatOptions = (function() {
    var bad_statuses, bad_types, critical_priority, high_priority, low_priority, med_priority;

    function FormatOptions() {}

    bad_statuses = ["QA Failed"];

    bad_types = ["Production Issue", "Bug", "Defect"];

    low_priority = ["Low"];

    med_priority = ["Medium"];

    high_priority = ["High"];

    critical_priority = ["Blocker", "Critical"];

    return FormatOptions;

  })();

  module.exports = {
    FormatOptions: FormatOptions
  };

}).call(this);
