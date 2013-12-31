# create wrap function for formatting
wrap = require('wordwrap')(8, 80)

# sometime you want to pad: here it is
pad = require('wordwrap')(2, 100)

# moment because we're not filthy animals
moment = require('moment')

# use colors it owns
colors = require('colors')

# [Printing Options docs/source](format-options.html)
options = require('./format-options')

# ## PrettyPrinter ##
#
# This creates the fancy output your eyes want to see.
class PrettyPrinter
    # Statuses that should be colored
    colors.setTheme
        success: "green"
        error: "red"
        log: "white"
        low:"green"
        medium:"yellow"
        high:"magenta"
        crit:"red"

    # ## Pretty Print List ##
    #
    # Prints a listing of items with the ability for a detailed print.
    # Color logic is weak and will be addressed more cleanly.
    prettyPrintList: (issue, detail) ->
        process.stdout.write issue.key.log.bold
        issue.fields.summary = "None" unless issue.fields.summary?
        dash()
        process.stdout.write issue.fields.summary.log

        if detail
            if issue.fields.issuetype?
                process.stdout.write "Type:".log.bold
                if issue.fields.issuetype.name in options.bad_types
                    process.stdout.write pad(issue.fields.issuetype.name).high
                else
                    process.stdout.write pad(issue.fields.issuetype.name).low
            newline()

            process.stdout.write "Status:".log.bold
            if issue.fields.status.name in options.bad_statuses
                process.stdout.write pad(issue.fields.status.name).red
            else
                process.stdout.write pad(issue.fields.status.name).green
            newline()

            process.stdout.write "Assigned To:".log.bold
            process.stdout.write pad(issue.fields.assignee.name).log
            newline()

        newline()

    # ## Pretty Print Issue ##
    #
    # Prints an issue with Summary information, or with expanded detail.
    prettyPrintIssue: (issue, detail)->
        newline()
        seperator().yellow
        newline()

        process.stdout.write "Issue:".log.bold
        process.stdout.write pad(issue.key).log.bold
        issue.fields.summary = "None" unless issue.fields.summary?
        dash()
        process.stdout.write issue.fields.summary.log
        newline()

        if detail
            if issue.fields.description?
                process.stdout.write "Description:".log.bold
                newline()
                txt = issue.fields.description.slice(0,300)
                process.stdout.write wrap(txt).log

                if txt.length > 300
                    newline()
                    process.stdout.write pad("...")

                newline()

            if issue.fields.issuetype?
                process.stdout.write "Type:".log.bold
                if issue.fields.issuetype.name in options.bad_types
                    process.stdout.write pad(issue.fields.issuetype.name).high
                else
                    process.stdout.write pad(issue.fields.issuetype.name).low
                newline()

            process.stdout.write "Status:".log.bold
            if issue.fields.status.name in options.bad_statuses
                process.stdout.write pad(issue.fields.status.name).red
            else
                process.stdout.write pad(issue.fields.status.name).green
            newline()

            process.stdout.write "Priority:".log.bold
            if issue.fields.priority.name in options.med_priority
                process.stdout.write pad(issue.fields.priority.name).medium
            else if issue.fields.priority.name in options.high_priority
                process.stdout.write pad(issue.fields.priority.name).high
            else if issue.fields.priority.name in options.critical_priority
                process.stdout.write pad(issue.fields.priority.name).crit
            else
                process.stdout.write pad(issue.fields.priority.name).low
            newline()

            process.stdout.write "Assigned To:".log.bold
            process.stdout.write pad(issue.fields.assignee.name).log
            newline()

            process.stdout.write "Reporter:".log.bold
            process.stdout.write pad(issue.fields.reporter.name).log
            newline()

            process.stdout.write "Created On:".log.bold
            # this isn't localized I know.
            dt = moment(issue.fields.created).format("MM/D/YYYY h:mm:ss a")
            process.stdout.write pad(dt)
            newline()

            process.stdout.write "Updated On:".log.bold
            # this isn't localized I know.
            dt = moment(issue.fields.updated).format("MM/D/YYYY h:mm:ss a")
            process.stdout.write pad(dt)
            newline()

        newline()

    # ## Do some fancy formatting on issue types ##
    #
    # Helper really, called when adding to not show certian issue types
    # and to format
    prettyPrintIssueTypes: (issueType, index)->
        # ignore subtasks for now that's a monster (linking, etc)
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
        process.stdout.write transition.id
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
        process.stdout.write project.key
        dash()
        process.stdout.write project.name
        newline()

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

    # Private helpers because copy and paste is OK,
    # but make it clean(er) with functs
    newline = () ->
        process.stdout.write "\n"

    dash = () ->
        process.stdout.write " - "

    seperator = () ->
        txt=""
        for i in [1..80]
            txt += "*"
        process.stdout.write txt

module.exports = {
    PrettyPrinter
}
