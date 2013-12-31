## jira-term

[![Build Status](https://travis-ci.org/bryangrimes/jira-term.png?branch=master)](https://travis-ci.org/bryangrimes/jira-term)

## Get the low down before you get started
[GitHub Documentation](http://bryangrimes.github.io/jira-term/)

This is a fork of the [jira-cli](http://tebriel.github.com/jira-cli/) project which isn't active at the moment, so I built on top of it.  Also, I forked and used the [jira-cli](http://tebriel.github.com/jira-cli/) project because my current day job has very tightly controlled custom workflows where various fields can be required based on workflow actions, and I wanted to keep that separate.

This is also a project for me to get back into CoffeeScript and to better understand using Travis, GitHub pages, self documenting code, and other tools.  Make no mistake, I use this in my daily work, but until version 0.3.0 or so is hit, this might be buggy in edge cases (e.g. custom fields required on create, and so on).

## Why use this?
Managing an eight person dev team, plus having work of my own, I'm stuck in Jira about three hours a day.  That's answering status questions, attending scrums and pulling lists for people, prepping and tagging releases, and then I have my own queue in Jira for designs and prototype I owe for various projects.  Easily an hour of the three I spend is fidning what to click in the Jira UI and then fumbling around.  I wanted, and needed, a faster way to get my answers and data in something I'm fairly fast at: shell.

Oh and I love Node.js and CoffeeScript, and since the Jira-cli project had about 80% of what I needed, this all worked out well.

This is mainly a fork I created for my day job's Jira work...so for now if you have a problem adding a new item, or selecting a status/transition let me know.

## How do I get this?

*  Install the module with: `npm install -g jira-term`
*  Run it with `jira-term`

## Great, so what does it do now?

*  Lists your issues by default
*  List all projects you have access to
*  Finds an issue by Key (AB-123) or Id (123456)
*  Opens an issue
*  Allows user to add a new ticket to different projects
*  Transitions an issue (shows all available transition states)
*  Adds a worklog to an issue
*  Allow searching to be limited by project id or name
*  Returns results in a simple or detailed output
*  Colors things you care about which is (somewhat) customizable


## Known things that aren't working 100%

* Transitions are being listed with the Jira ID and not 1,2,3,etc
* Adding a new issue want's "QA Acceptance Criteria".  That's from my day job, and will be extracted and removed
* Mixing args is awkward, need to throw errors if you mix when not needed/expected

## What's the short-term roadmap?

*  Fix bugs - Meh.
*  Handle custom fields on create/transition to keep everyone working smoothly
*  Better/refactored testing FOR SURE
*  Fully customizable colors and options
*  Ability to open your browser on a selected project or issue
*  Support for arrays of items to transition, log work, etc

## Documentation ##

[GitHub Documentation](http://bryangrimes.github.io/jira-term/docs/jira.html)

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
*  _0.1.3 I can't spell_
*  _0.1.4 documentation_

## License

Licensed under the MIT license.  I forked, you fork, whatever let's all have some fun and get shit done. 
