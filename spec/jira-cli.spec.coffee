fs = require 'fs'
path = require 'path'

colors = require 'colors'

jira = require '../src/jira-cli.coffee'

# These seem to be a bit silly, gets me more familiar with spies though, so I
# guess that's a good thing.

describe "JiraCli", ->
    beforeEach ->
        config =
            host: 'localhost'
            port: 80
            user: 'test'
            password: 'test'

        @jiraCli = new jira.JiraHelper config
        @cb = jasmine.createSpy 'callback'
        spyOn @jiraCli.pp, 'prettyPrintIssue'
        spyOn @jiraCli.pp, 'prettyPrintLog'
        spyOn @jiraCli.pp, 'prettyPrintSuccess'
        spyOn @jiraCli.pp, 'prettyPrintError'
        spyOn @jiraCli.pp, 'prettyPrintList'
        spyOn @jiraCli, 'dieWithFire'

    it "Gets the requested issue", ->
        spyOn @jiraCli.jira, 'findIssue'
        @jiraCli.getIssue 1, false
        expect(@jiraCli.jira.findIssue)
            .toHaveBeenCalledWith 1, jasmine.any Function

        @jiraCli.jira.findIssue.mostRecentCall.args[1] null, "response"
        expect(@jiraCli.pp.prettyPrintIssue)
            .toHaveBeenCalledWith "response", false

        @jiraCli.jira.findIssue.mostRecentCall.args[1] "error"
        expect(@jiraCli.pp.prettyPrintError)
            .toHaveBeenCalledWith "Error finding issue: error"

    it "Gets the issue types", ->
        spyOn @jiraCli.jira, 'listIssueTypes'
        @jiraCli.getIssueTypes @cb

        @jiraCli.jira.listIssueTypes.mostRecentCall.args[0] null, "response"
        expect(@cb).toHaveBeenCalledWith "response"

        @jiraCli.jira.listIssueTypes.mostRecentCall.args[0] "error"
        expect(@jiraCli.pp.prettyPrintError)
            .toHaveBeenCalledWith "Error listing issueTypes: error"
        expect(@jiraCli.dieWithFire).toHaveBeenCalled()

    it "Adds a new issue", ->
        issue = @jiraCli.createIssueObject 'project', 'summary', 'issueType',
            'description'
        spyOn @jiraCli.jira, 'addNewIssue'
        @jiraCli.addIssue 'summary', 'description', 'issueType', 'project'
        expect(@jiraCli.jira.addNewIssue)
            .toHaveBeenCalledWith issue, jasmine.any Function

        @jiraCli.jira.addNewIssue.mostRecentCall.args[1] null,
            key: 'response'
        expect(@jiraCli.pp.prettyPrintSuccess)
            .toHaveBeenCalledWith "Issue response has been created"

        @jiraCli.jira.addNewIssue.mostRecentCall.args[1] "error"
        expect(@jiraCli.pp.prettyPrintError)
            .toHaveBeenCalledWith "Error creating issue: \"error\""

    it "Deletes an Issue", ->
        spyOn @jiraCli.jira, 'deleteIssue'
        @jiraCli.deleteIssue 1

        expect(@jiraCli.jira.deleteIssue)
            .toHaveBeenCalledWith 1, jasmine.any Function

        @jiraCli.jira.deleteIssue.mostRecentCall.args[1] "error"
        expect(@jiraCli.pp.prettyPrintError)
            .toHaveBeenCalledWith "Error deleting issue: error"

        @jiraCli.jira.deleteIssue.mostRecentCall.args[1] null, "success"
        expect(@jiraCli.pp.prettyPrintSuccess)
            .toHaveBeenCalledWith "Issue 1 was deleted"

    it "Adds a worklog", ->
        worklog =
            comment: 'comment'
            timeSpent: 'timeSpent'
        spyOn @jiraCli.jira, 'addWorklog'
        @jiraCli.addWorklog 1, 'comment', 'timeSpent', true

        expect(@jiraCli.jira.addWorklog)
            .toHaveBeenCalledWith 1, worklog, jasmine.any Function

        @jiraCli.jira.addWorklog.mostRecentCall.args[2] null, "response"
        expect(@jiraCli.pp.prettyPrintSuccess)
            .toHaveBeenCalledWith "Worklog was added"

        @jiraCli.jira.addWorklog.mostRecentCall.args[2] "error"
        expect(@jiraCli.pp.prettyPrintError)
            .toHaveBeenCalledWith "Error adding worklog: error"

        expect(@jiraCli.dieWithFire).toHaveBeenCalled()

    it "Adds a worklog, but doesn't quit", ->
        spyOn @jiraCli.jira, 'addWorklog'
        @jiraCli.addWorklog 1, 'comment', 'timeSpent', false
        @jiraCli.jira.addWorklog.mostRecentCall.args[2] null, "response"
        expect(@jiraCli.dieWithFire).not.toHaveBeenCalled()

    it "Lists transitions", ->
        spyOn @jiraCli.jira, 'listTransitions'

        @jiraCli.listTransitions 1, @cb
        expect(@jiraCli.jira.listTransitions)
            .toHaveBeenCalledWith 1, jasmine.any Function

        @jiraCli.jira.listTransitions.mostRecentCall.args[1] null, "transitions"
        expect(@cb).toHaveBeenCalledWith "transitions"

        @jiraCli.jira.listTransitions.mostRecentCall.args[1] "error"
        expect(@jiraCli.pp.prettyPrintError)
            .toHaveBeenCalledWith "Error getting transitions: error"
        expect(@jiraCli.dieWithFire).toHaveBeenCalled()

    it "Transitions an Issue", ->
        issueUpdate =
            transition:
                id: 'transition'
        spyOn @jiraCli.jira, 'transitionIssue'
        @jiraCli.transitionIssue 1, 'transition'
        expect(@jiraCli.jira.transitionIssue)
            .toHaveBeenCalledWith 1, issueUpdate, jasmine.any Function

        @jiraCli.jira.transitionIssue.mostRecentCall.args[2] null, "response"
        expect(@jiraCli.pp.prettyPrintLog)
            .toHaveBeenCalledWith "Issue 1 was transitioned" # #{color "transitioned", 'green'}"

        @jiraCli.jira.transitionIssue.mostRecentCall.args[2] "error"
        expect(@jiraCli.pp.prettyPrintError)
            .toHaveBeenCalledWith "Error transitioning issue: error"

        expect(@jiraCli.dieWithFire).toHaveBeenCalled()

    it "Searches Jira", ->
        fields = ["summary", "status", "assignee"]
        spyOn @jiraCli.jira, 'searchJira'

        @jiraCli.searchJira 'query', true
        expect(@jiraCli.jira.searchJira)
            .toHaveBeenCalledWith 'query', fields, jasmine.any Function

        expect(@jiraCli.jira.searchJira.mostRecentCall.args[1])
            .toEqual fields

        @jiraCli.jira.searchJira.mostRecentCall.args[2] null, issues: [1]
        expect(@jiraCli.pp.prettyPrintList).toHaveBeenCalledWith 1, true

        @jiraCli.jira.searchJira.mostRecentCall.args[2] "error"
        expect(@jiraCli.pp.prettyPrintError)
            .toHaveBeenCalledWith "Error retreiving issues list: error"

    it "Gets the user's OPEN issues", ->
        jql = "assignee = \"test\" AND resolution = unresolved"
        spyOn @jiraCli, 'searchJira'

        @jiraCli.getMyIssues true, true

        expect(@jiraCli.searchJira).toHaveBeenCalledWith jql, true

    it "Gets the user's OPEN issues for all open sprints", ->
        jql = "assignee = \"test\" AND resolution = unresolved AND sprint in openSprints()"
        spyOn @jiraCli, 'searchJira'

        @jiraCli.getMyIssues true, true, null, true

        expect(@jiraCli.searchJira).toHaveBeenCalledWith jql, true

    it "Gets ALL the user's issues", ->
        jql = "assignee = \"test\""
        spyOn @jiraCli, 'searchJira'

        @jiraCli.getMyIssues false, true

        expect(@jiraCli.searchJira).toHaveBeenCalledWith jql, true

    it "Gets the user's projects", ->
        spyOn @jiraCli.jira, 'listProjects'
        @jiraCli.getMyProjects @cb

        @jiraCli.jira.listProjects.mostRecentCall.args[0] null, "list"
        expect(@cb).toHaveBeenCalledWith "list"

        @jiraCli.jira.listProjects.mostRecentCall.args[0] "error"
        expect(@jiraCli.pp.prettyPrintError)
            .toHaveBeenCalledWith "Error listing projects: error"

        expect(@jiraCli.dieWithFire).toHaveBeenCalled()
