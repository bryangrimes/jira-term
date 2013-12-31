# Because colors are pretty
# removed ansi-colors in favor of colors. Cleaner IMO.
colors = require 'colors'

# [PrettyPrinter docs/source](pretty-printer.html)
PrettyPrinter = require('./pretty-printer').PrettyPrinter

JiraApi = require('jira').JiraApi

# Enum for search types, used in the stdout formatting
# a wee bit hacky at the moment
searchTypes = {Issue:0, List:1}

# ## JiraHelper ##
#
# This does the fancy talking to JiraApi for us. It formats the objects the way
# that Jira expects them to come in. Basically a wrapper for node-jira-devel
class JiraHelper
    # ## Constructor ##
    #
    # Builds a new JiraCli with the config settings
    constructor: (@config)->
        unless @config.strictSSL?
            @config.strictSSL = true
        unless @config.protocol?
            @config.protocol = 'http:'

        @jira = new JiraApi(@config.protocol, @config.host,
            @config.port, @config.user, @config.password, '2',
            false, @config.strictSSL)
        @response = null
        @error = null
        @pp = new PrettyPrinter

    dieWithFire: ->
        process.exit()

    # ## Get Issue ##
    #
    # Searches Jira for the issue number requested
    # this can be either a key AB-123 or just the number 123456
    getIssue: (issueNum, details)->
        @jira.findIssue issueNum, (error, response) =>
            if response?
                @response = response
                @pp.prettyPrintIssue response, details
            else
                @error = error if error?
                @pp.prettyPrintError  "Error finding issue: #{error}"

    # ## Get Issue Types ##
    #
    # Gets a list of all the available issue types
    getIssueTypes: (callback)->
        @jira.listIssueTypes (error, response) =>
            if response?
                callback response
            else
                @pp.prettyPrintError "Error listing issueTypes: #{error}"
                @dieWithFire()

    createIssueObject: (project, summary, issueType, description, criteria) ->
        # TO DO:
        # the last arg should be an array of keys and values
        # that are non-standard
        fields:
            project: { key :project }
            summary: summary
            issuetype: { id:issueType }
            assignee: { name:@config.user }
            description: description
            customfield_10503: criteria

    # ## Add Issue ##
    #
    # ### Takes ###
    # *  summary: details for the title of the issue
    # *  description: more detailed than summary
    # *  issue type: Id of the type (types are like bug, feature)
    # *  project: this is the id of the project that you're assigning the issue
    # to
    addIssue: (summary, description, issueType, project, criteria) ->
        newIssue = @createIssueObject project, summary, issueType,
                    description, criteria

        @jira.addNewIssue newIssue, (error, response) =>
            if response?
                @response = response if response?
                @pp.prettyPrintSuccess "Issue #{response.key} has been created"
            else
                # The error object is non-standard here from Jira, I'll parse
                # it better later
                @error = error if error?
                @msg = "Error creating issue: #{JSON.stringify(error)}"
                @pp.prettyPrintError @msg

            @dieWithFire()

    # ## Delete an Issue ##
    #
    # Deletes an issue (if you have permissions) from Jira. I haven't tested
    # this successfully because I don't have permissions.
    deleteIssue: (issueNum)->
        # Don't have permissions currently
        @jira.deleteIssue issueNum, (error, response) =>
            if response?
                @response = response
                @pp.prettyPrintSuccess "Issue #{issueNum} was deleted"
            else
                @error = error if error?
                @pp.prettyPrintError "Error deleting issue: #{error}"

    # ## Add Worklog Item ##
    #
    # Adds a simple worklog to an issue
    addWorklog: (issueId, comment, timeSpent, exit)->
        worklog =
            comment:comment
            timeSpent:timeSpent
        @jira.addWorklog issueId, worklog, (error, response)=>
            if response?
                @pp.prettyPrintSuccess "Worklog was added"
            else
                @error = error if error?
                @pp.prettyPrintError "Error adding worklog: #{error}"
            @dieWithFire() if exit

    # ## List Transitions ##
    #
    # List the transitions available for an issue
    listTransitions: (issueNum, callback) ->
        @jira.listTransitions issueNum, (error, transitions)=>
            if transitions?
                callback transitions
            else
                @pp.prettyPrintError "Error getting transitions: #{error}"
                @dieWithFire()

    # ## Transition Issue ##
    #
    # Transitions an issue in Jira
    #
    # ### Takes ###
    #
    # *  issueNum: the Id of the issue (either the AB-123 or the 123456)
    # *  transitionNum: this is the id of the transition to apply to the issue
    transitionIssue: (issueNum, transitionNum)->
        issueUpdate =
            transition:
                id:transitionNum
        @jira.transitionIssue issueNum, issueUpdate, (error, response) =>
            if response?
                @response = response
                @pp.prettyPrintLog "Issue #{issueNum} " +
                    "was transitioned" # #{color("transitioned", "green")}"
            else
                @error = error if error?
                @pp.prettyPrintError "Error transitioning issue: #{error}"

            @dieWithFire()

    # ## Search Jira ##
    #
    # Passes a jql formatted query to jira for search
    #
    # ### Takes ###
    #
    # *  searchQuery: a jql formatted search query string
    # shows all otherwise
    searchJira: (searchQuery, details, type)->
        fields = ["summary", "status", "assignee"]
        @jira.searchJira searchQuery, fields, (error, issueList) =>
            if issueList?
                @myIssues = issueList
                for issue in issueList.issues
                    switch type
                        when searchTypes.Issue
                            @pp.prettyPrintIssue issue, details
                        else # less is better as default
                            @pp.prettyPrintList issue, details
            else
                @error = error if error?
                @pp.prettyPrintError "Error retreiving issues list: #{error}"

    # ## Get My Issues ##
    #
    # Gets a list of issues for the user listed in the config
    #
    # ### Takes ###
    #
    # *  open: `boolean` which indicates if only open items should be shown,
    # shows all otherwise
    getMyIssues: (open, details, projects)->
        jql = "assignee = \"#{@config.user}\""
        if open
            jql += ' AND resolution = unresolved'
        jql += projects if projects?
        @searchJira jql, details
        return

    # ## List all Projects ##
    #
    # This lists all the projects viewable with your account
    getMyProjects: (callback)->
        @jira.listProjects (error, projectList) =>
            if projectList?
                callback projectList
            else
                @pp.prettyPrintError "Error listing projects: #{error}"
                @dieWithFire()


module.exports = {
    JiraHelper
}
