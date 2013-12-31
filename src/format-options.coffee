
# ## External printing configurations
#
# Code reuse is the point here...
#will be scrapped in leiu of user created configs in a later version
bad_statuses = ["QA Failed"]
bad_types = ["Production Issue", "Bug", "Defect"]
low_priority =["Low"]
med_priority =["Medium"]
high_priority =["High"]
critical_priority =["Blocker", "Critical"]

module.exports = {
    bad_statuses,
    bad_types,
    low_priority,
    med_priority,
    high_priority,
    critical_priority
}