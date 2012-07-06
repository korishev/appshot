Feature: Appshot CLI mode
  In order to take consistent snapshots of my data volumes
  I want to check my application parameters
  So I have the options I need

  Scenario: App displays help when asked
    When I get help for "appshot"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version      |
      |-c             |
      |--config_file  |
      |-l             |
      |--list_appshots|
      |--list-appshots|
    And the banner should document that this app's arguments are:
      |appshot_names...| optional|

  Scenario: User asks for list of appshots from empty file
    Given an empty file named "/tmp/empty.cfg"
    When I successfully run `appshot -c /tmp/empty.cfg --list`
    Then the output should contain "There are no appshots configured"

  Scenario: User asks for list of appshots from file with one appshot
    Given a file named "/tmp/one_appshot.cfg" with:
    """
    appshot "mysql_userdb" do
      mysql name: "userdb", port: 1536, user: "pooky"
      xfs "/mnt/mysql"
      ext4 "/mnt/mysql/log"
      ebs "vol-4ed40599"
      prune max_copies: 15, retain: 5.days
    end
    """
    When I successfully run `appshot -c /tmp/one_appshot.cfg --list`
    Then the output should contain "There is 1 appshot configured"

