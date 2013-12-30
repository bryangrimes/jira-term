# jira-term

[![Build Status](https://travis-ci.org/bryangrimes/jira-term.png?branch=master)](https://travis-ci.org/bryangrimes/jira-term)

This is a fork of the [jira-cli](http://tebriel.github.com/jira-cli/) project which isn't actively maintained anymore so I built on top of it for now.    

## Getting Started

*  This is mainly a fork for my day job's Jira work, so there are some customizations to be made before this is availble via npm.
*   Install the module with: `npm install -g jira-term`
*  Run it with `jira-term`

## What does it do?

*  Lists your issues by default
*  List all projects you have access to
*  Finds an issue by Key (AB-123) or Id (123456)
*  Opens an issue 
*  Allows user to add a new ticket to different projects
*  Transitions an issue (shows all available transition states)
*  Adds a worklog to an issue
*  Allow searching to be limited by project id
*  Returns results in a simple or detailed output
*  Colors things you care about which is customizable

## TODO

*  Better/refactored testing FOR SURE
*  Fully customizable colors and options
*  Ability to open your browser on a selected project or issue
*  Support for arrays of items to transition, log work, etc

## Documentation ##

[GitHub Documentation](http://bryangrimes.github.com/jira-term/)

## Examples ##

`jira-term -l` to list your assigned items

`jira-term -f AB-123` to find an item

`jira-term -f AB-123 -d` to find an item and show details

`jira-term -p` to list al projects

`jira-term -t AB-123` to transition the item

## Notes ##

This is built off of the great [node-jira](https://github.com/steves/node-jira) API so please refer to their [documentation](https://github.com/steves/node-jira/blob/master/README.md) on the requirements needed for connectivity and security to your Jira instance.

If you use `https:` for jira, add `"protocol": "https:"` to your .jiraclirc.json
If your ssl certs are also self-signed add: `"strictSSL": false` to your .jiraclirc.json

## Testing ##

Using jasmine-node with grunt currently and need a ton of work.  Spies are working, but brute force unit tests are needed for coverage.


## Release History

*  _0.0.1 Initial Release_
*  _0.0.2 npm updates_

## Slated For Next Release (0.1.1)
* Ability to create and maintain print-options with an arg to make it easy to change colors and whatnot
* More tests
* Better Travis integration

## License

Licensed under the MIT license.  I forked, you fork, whatever let's all have some fun and get shit done. 
