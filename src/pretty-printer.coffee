wrap = require('wordwrap')(8, 80)

# use moment for date magic
moment = require('moment')

# removed ansi-colors in favor of colors. Cleaner IMO.
colors = require('colors')

class PrettyPrinter
    # hardcoded (for now) statuses that should be colored
    bad_statuses = ["QA Failed", "Backlog"]
    good_statuses = ["QA Passed", "Closed", "Task Complete"]

    bad_types = ["Production Issue", "Bug"]

    low_priority =["Low"]
    med_priority =["Medium"]
    high_priority =["High"]
    critical_priority =["Blocker", "Critical"]

    colors.setTheme
        success: "green"
        error: "red"
        log: "white"
        low:"green"
        medium:"yellow"
        high:"magenta"
        crit:"red"

    prettyPrintIssue: (issue, detail)->
        # the color logic seems hacky but works as first pass
        process.stdout.write issue.key.log.bold
        issue.fields.summary = "None" unless issue.fields.summary?
        dash()
        process.stdout.write issue.fields.summary.log
        newline()

        if detail
            if issue.fields.description?
                process.stdout.write "Description:\n".log.bold
                txt = issue.fields.description.slice(0,300)
                process.stdout.write wrap(txt).log
                newline()
                process.stdout.write wrap("...")
                newline()

            if issue.fields.issuetype?
                process.stdout.write "Type:\n".log.bold
                if issue.fields.issuetype.name in bad_types
                    process.stdout.write wrap(issue.fields.issuetype.name).high
                else
                    process.stdout.write wrap(issue.fields.issuetype.name).low
                newline()

            if issue.fields.status?
                process.stdout.write "Status:\n".log.bold
                if issue.fields.status.name in bad_statuses
                    process.stdout.write wrap(issue.fields.status.name).red
                else
                    process.stdout.write wrap(issue.fields.status.name).green
                newline()

            if issue.fields.priotity?
                process.stdout.write "Priority:\n".log.bold
                if issue.fields.priority.name in med_priority
                    process.stdout.write wrap(issue.fields.priority.name).medium
                else if issue.fields.priority.name in high_priority
                    process.stdout.write wrap(issue.fields.priority.name).high
                else if issue.fields.priority.name in bad_statuses
                    process.stdout.write wrap(issue.fields.priority.name).crit
                else
                    process.stdout.write wrap(issue.fields.priority.name).low
                newline()

            if issue.fields.reporter?
                process.stdout.write "Reporter:\n".log.bold
                process.stdout.write wrap(issue.fields.reporter.name).log
                newline()

            if issue.fields.created?
                process.stdout.write "Created On:\n".log.bold
                # this isn't localized I know.
                dt = moment(issue.fields.created).format("MM/d/YYYY h:mm:ss a")
                process.stdout.write wrap(dt)
                newline()

            if issue.fields.assignee?
                process.stdout.write "Assigned To:\n".log.bold
                process.stdout.write wrap(issue.fields.assignee.name).log
                newline()

            newline()

    # ## Do some fancy formatting on issue types ##
    prettyPrintIssueTypes: (issueType, index)->
        # ignore subtasks for now that's a whole different thing with linking
        if issueType.subtask == false
            process.stdout.write issueType.id.log.bold
            dash()
            process.stdout.write issueType.name
            if issueType.description.length > 0
                dash()
                process.stdout.write issueType.description
            newline()

    # ## Pretty Print Transition ##
    #
    # Show a transition with the ID in bold followed by the name
    prettyPrintTransition: (transition, index) ->
        process.stdout.write index.log.bold
        dash()
        process.stdout.write transition.name
        newline()

    # ## Pretty Print Projects ##
    #
    # Prints the project list in a non-awful format
    prettyPrintProject: (project) ->
        key = project.key
        while key.length < 12
            key = ' ' + key
        process.stdout.write index.log.bold
        dash()
        process.stdout.write project.id
        dash()
        process.stdout.write project.name
        newline()

    # these could all be refactored to be on methog with two args.

    # ## Pretty Print Errors ##
    #
    # Prints errors red
    prettyPrintError: (message) ->
        process.stdout.write message.error
        newline()

    # ## Pretty Print Successes ##
    #
    # Prints success notifications
    prettyPrintSuccess: (message) ->
        process.stdout.write message.success
        newline()

     # ## Pretty Print Logs ##
    #
    # Prints general log notifications
    prettyPrintLog: (message) ->
        process.stdout.write message.log
        newline()

    # private helpers
    newline = () ->
        process.stdout.write "\n"

    dash = () ->
        process.stdout.write " - "

module.exports = {
    PrettyPrinter
}
