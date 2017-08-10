# JIRA
warn "PR is classed as Work in Progress" if github.pr_title.include? "[WIP]"
warn "PR does not have a Jira ticket i.e [CSI-XXX]" if !github.pr_title.include? "[CSI]"

# Code Coverage
xcov.report(
  scheme: 'NexmoConversation',
  workspace: 'Example/NexmoConversation.xcworkspace',
  include_targets: 'Demo.app',
  minimum_coverage_percentage: 63
)

# Xcode
xcode_summary.report 'xcodebuild.json'
xcode_summary.ignored_files = '**/Pods/**'
xcode_summary.report 'xcodebuild.json'

# Conflict 
conflict_checker.check_conflict_and_comment

# New files paths
message(message: git.added_files)