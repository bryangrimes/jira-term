(function() {
  var PrettyPrinter, colors, moment, wrap,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  wrap = require('wordwrap')(8, 80);

  moment = require('moment');

  colors = require('colors');

  PrettyPrinter = (function() {
    var bad_statuses, bad_types, critical_priority, dash, good_statuses, high_priority, low_priority, med_priority, newline;

    function PrettyPrinter() {}

    bad_statuses = ["QA Failed", "Backlog"];

    good_statuses = ["QA Passed", "Closed", "Task Complete"];

    bad_types = ["Production Issue", "Bug"];

    low_priority = ["Low"];

    med_priority = ["Medium"];

    high_priority = ["High"];

    critical_priority = ["Blocker", "Critical"];

    colors.setTheme({
      success: "green",
      error: "red",
      log: "white",
      low: "green",
      medium: "yellow",
      high: "magenta",
      crit: "red"
    });

    PrettyPrinter.prototype.prettyPrintIssue = function(issue, detail) {
      var dt, txt, _ref, _ref1, _ref2, _ref3, _ref4;
      process.stdout.write(issue.key.log.bold);
      if (issue.fields.summary == null) {
        issue.fields.summary = "None";
      }
      dash();
      process.stdout.write(issue.fields.summary.log);
      newline();
      if (detail) {
        if (issue.fields.description != null) {
          process.stdout.write("Description:\n".log.bold);
          txt = issue.fields.description.slice(0, 300);
          process.stdout.write(wrap(txt).log);
          newline();
          process.stdout.write(wrap("..."));
          newline();
        }
        if (issue.fields.issuetype != null) {
          process.stdout.write("Type:\n".log.bold);
          if (_ref = issue.fields.issuetype.name, __indexOf.call(bad_types, _ref) >= 0) {
            process.stdout.write(wrap(issue.fields.issuetype.name).high);
          } else {
            process.stdout.write(wrap(issue.fields.issuetype.name).low);
          }
          newline();
        }
        if (issue.fields.status != null) {
          process.stdout.write("Status:\n".log.bold);
          if (_ref1 = issue.fields.status.name, __indexOf.call(bad_statuses, _ref1) >= 0) {
            process.stdout.write(wrap(issue.fields.status.name).red);
          } else {
            process.stdout.write(wrap(issue.fields.status.name).green);
          }
          newline();
        }
        if (issue.fields.priotity != null) {
          process.stdout.write("Priority:\n".log.bold);
          if (_ref2 = issue.fields.priority.name, __indexOf.call(med_priority, _ref2) >= 0) {
            process.stdout.write(wrap(issue.fields.priority.name).medium);
          } else if (_ref3 = issue.fields.priority.name, __indexOf.call(high_priority, _ref3) >= 0) {
            process.stdout.write(wrap(issue.fields.priority.name).high);
          } else if (_ref4 = issue.fields.priority.name, __indexOf.call(bad_statuses, _ref4) >= 0) {
            process.stdout.write(wrap(issue.fields.priority.name).crit);
          } else {
            process.stdout.write(wrap(issue.fields.priority.name).low);
          }
          newline();
        }
        if (issue.fields.reporter != null) {
          process.stdout.write("Reporter:\n".log.bold);
          process.stdout.write(wrap(issue.fields.reporter.name).log);
          newline();
        }
        if (issue.fields.created != null) {
          process.stdout.write("Created On:\n".log.bold);
          dt = moment(issue.fields.created).format("MM/d/YYYY h:mm:ss a");
          process.stdout.write(wrap(dt));
          newline();
        }
        if (issue.fields.assignee != null) {
          process.stdout.write("Assigned To:\n".log.bold);
          process.stdout.write(wrap(issue.fields.assignee.name).log);
          newline();
        }
        return newline();
      }
    };

    PrettyPrinter.prototype.prettyPrintIssueTypes = function(issueType, index) {
      if (issueType.subtask === false) {
        process.stdout.write(issueType.id.log.bold);
        dash();
        process.stdout.write(issueType.name);
        if (issueType.description.length > 0) {
          dash();
          process.stdout.write(issueType.description);
        }
        return newline();
      }
    };

    PrettyPrinter.prototype.prettyPrintTransition = function(transition, index) {
      process.stdout.write(transition.id);
      dash();
      process.stdout.write(transition.name);
      return newline();
    };

    PrettyPrinter.prototype.prettyPrintProject = function(project) {
      var key;
      if (!project.name.match(/r?z\ ?/)) {
        key = project.key;
        while (key.length < 12) {
          key = ' ' + key;
        }
        process.stdout.write(project.key);
        dash();
        process.stdout.write(project.name);
        return newline();
      }
    };

    PrettyPrinter.prototype.prettyPrintError = function(message) {
      process.stdout.write(message.error);
      return newline();
    };

    PrettyPrinter.prototype.prettyPrintSuccess = function(message) {
      process.stdout.write(message.success);
      return newline();
    };

    PrettyPrinter.prototype.prettyPrintLog = function(message) {
      process.stdout.write(message.log);
      return newline();
    };

    newline = function() {
      return process.stdout.write("\n");
    };

    dash = function() {
      return process.stdout.write(" - ");
    };

    return PrettyPrinter;

  })();

  module.exports = {
    PrettyPrinter: PrettyPrinter
  };

}).call(this);
