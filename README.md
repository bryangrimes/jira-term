## jira-term

[![Build Status](https://travis-ci.org/bryangrimes/jira-term.png?branch=master)](https://travis-ci.org/bryangrimes/jira-term)

This is a fork of the [jira-cli](http://tebriel.github.com/jira-cli/) project which isn't active at the moment, so I built on top of it.  Also, I forked and used the [jira-cli](http://tebriel.github.com/jira-cli/) project because my current day job has very tightly controlled custom workflows where various fields can be required based on workflow actions, and I wanted to keep that seperate.

This is also a project for me to get back into CoffeeScript and to better understand using Travis, GitHub pages, self documenting code, and other tools.  Make no mistake, I use this in my daily work, but until version 0.3.0 or so is hit, this might be buggy in edge cases (e.g. custom fields required on create, and so on).

## Getting Started

*  This is mainly a fork I created for my day job's Jira work...so for now if you have a problem adding a new item, or selecting a status/transition let me know
*   Install the module with: `npm install -g jira-term`
*  Run it with `jira-term`

## What Does It Do?

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


## Known Issues

* Transitions are being listed with the Jira ID and not 1,2,3,etc
* Adding a new issue want's "QA Acceptance Criteria".  That's from my day job, and will be extracted and removed
* Mixing args is awkward, need to throw errors if you mix when not needed/expected
 
## TODO

*  Fix bugs - Meh.
*  Handle custom fields on create/transition to keep everyone working smoothly
*  Better/refactored testing FOR SURE
*  Fully customizable colors and options
*  Ability to open your browser on a selected project or issue
*  Support for arrays of items to transition, log work, etc

## Documentation ##

[GitHub Documentation](http://bryangrimes.github.io/jira-term/) - COMING SOON

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

Using jasmine-node with grunt currently and needs a ton of work.  Spies are working, but brute force unit tests are needed for coverage and sanity.


## Release History

*  _0.0.1 Initial Release_
*  _0.0.2 NPM Updates_
*  _0.1.0 Stable Release_
*  _0.1.1 meta update_
*  _0.1.2 meta update_
*  _0.1.3 I can't spell)_

## License

Licensed under the MIT license.  I forked, you fork, whatever let's all have some fun and get shit done. 
