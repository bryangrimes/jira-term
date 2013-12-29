(function() {
  var PrettyPrinter, colors, moment, pad, wrap,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  wrap = require('wordwrap')(8, 80);

  pad = require('wordwrap')(2, 100);

  moment = require('moment');

  colors = require('colors');

  PrettyPrinter = (function() {
    var bad_statuses, bad_types, critical_priority, dash, good_statuses, high_priority, low_priority, med_priority, newline, seperator;

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
      newline();
      seperator().yellow;
      newline();
      process.stdout.write("Issue:".log.bold);
      process.stdout.write(pad(issue.key).log.bold);
      if (issue.fields.summary == null) {
        issue.fields.summary = "None";
      }
      dash();
      process.stdout.write(issue.fields.summary.log);
      newline();
      if (detail) {
        if (issue.fields.description != null) {
          process.stdout.write("Description:".log.bold);
          newline();
          txt = issue.fields.description.slice(0, 300);
          process.stdout.write(wrap(txt).log);
          if (txt.length > 300) {
            newline();
            process.stdout.write(pad("..."));
          }
          newline();
        }
        if (issue.fields.issuetype != null) {
          process.stdout.write("Type:".log.bold);
          if (_ref = issue.fields.issuetype.name, __indexOf.call(bad_types, _ref) >= 0) {
            process.stdout.write(pad(issue.fields.issuetype.name).high);
          } else {
            process.stdout.write(pad(issue.fields.issuetype.name).low);
          }
          newline();
        }
        process.stdout.write("Status:".log.bold);
        if (_ref1 = issue.fields.status.name, __indexOf.call(bad_statuses, _ref1) >= 0) {
          process.stdout.write(pad(issue.fields.status.name).red);
        } else {
          process.stdout.write(pad(issue.fields.status.name).green);
        }
        newline();
        process.stdout.write("Priority:".log.bold);
        if (_ref2 = issue.fields.priority.name, __indexOf.call(med_priority, _ref2) >= 0) {
          process.stdout.write(pad(issue.fields.priority.name).medium);
        } else if (_ref3 = issue.fields.priority.name, __indexOf.call(high_priority, _ref3) >= 0) {
          process.stdout.write(pad(issue.fields.priority.name).high);
        } else if (_ref4 = issue.fields.priority.name, __indexOf.call(bad_statuses, _ref4) >= 0) {
          process.stdout.write(pad(issue.fields.priority.name).crit);
        } else {
          process.stdout.write(pad(issue.fields.priority.name).low);
        }
        newline();
        process.stdout.write("Assigned To:".log.bold);
        process.stdout.write(pad(issue.fields.assignee.name).log);
        newline();
        process.stdout.write("Reporter:".log.bold);
        process.stdout.write(pad(issue.fields.reporter.name).log);
        newline();
        process.stdout.write("Created On:".log.bold);
        dt = moment(issue.fields.created).format("MM/d/YYYY h:mm:ss a");
        process.stdout.write(pad(dt));
        newline();
        process.stdout.write("Updated On:".log.bold);
        dt = moment(issue.fields.updated).format("MM/d/YYYY h:mm:ss a");
        process.stdout.write(pad(dt));
        newline();
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

    seperator = function() {
      var i, txt, _i;
      txt = "*";
      for (i = _i = 1; _i <= 80; i = ++_i) {
        txt += "*";
      }
      return process.stdout.write(txt);
    };

    return PrettyPrinter;

  })();

  module.exports = {
    PrettyPrinter: PrettyPrinter
  };

}).call(this);
