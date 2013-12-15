(function() {
  var PrettyPrinter, color, wrap;

  color = require('ansi-color').set;

  wrap = require('wordwrap')(5, 65);

  PrettyPrinter = (function() {
    var dash, newline;

    function PrettyPrinter() {}

    PrettyPrinter.prototype.prettyPrintIssue = function(issue, detail) {
      var sumColor, _ref;
      sumColor = "green";
      if ((_ref = +issue.fields.status.id) === 5 || _ref === 6) {
        sumColor = "red";
      }
      process.stdout.write(color(issue.key, sumColor + "+bold"));
      if (issue.fields.summary == null) {
        issue.fields.summary = "None";
      }
      dash();
      process.stdout.write(issue.fields.summary);
      newline();
      if (detail && (issue.fields.description != null)) {
        process.stdout.write(color("Description:\n", "white+bold"));
        process.stdout.write(wrap(issue.fields.description));
        newline();
        return newline();
      }
    };

    PrettyPrinter.prototype.prettyPrintIssueTypes = function(issueType, index) {
      process.stdout.write(color(index, "white+bold"));
      dash();
      process.stdout.write(issueType.name);
      if (issueType.description.length > 0) {
        dash();
        process.stdout.write(issueType.description);
      }
      return newline();
    };

    PrettyPrinter.prototype.prettyPrintTransition = function(transition, index) {
      process.stdout.write(color(index, "white+bold"));
      pdash();
      process.stdout.write(transition.name);
      return newline();
    };

    PrettyPrinter.prototype.prettyPrintProject = function(project) {
      var key;
      key = project.key;
      while (key.length < 12) {
        key = ' ' + key;
      }
      process.stdout.write(color(key, "white+bold"));
      dash();
      process.stdout.write(project.id);
      dash();
      process.stdout.write(project.name);
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
