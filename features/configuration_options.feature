Feature: Configuration options
  In order to allow TestConfig to work with different project structures
  As a tester
  I want to configure where TestConfig looks for data

  Scenario: No custom configuration options set
    Given a "default.yml" file exists in the "config/environments" directory
    And a "TEST_ENV" environment variable exists and is set to "env.yml"
    When I do not set custom configuration options
    Then the "default.yml" file should be loaded from the "config/environments" directory
    And the "env.yml" file should be loaded from the "config/environments" directory

  Scenario: Custom default_file set
    Given a "custom_default.yml" file exists in the default directory
    When I set "default_file" to "custom_default.yml"
    Then the "custom_default.yml" file should be loaded from the default directory

  Scenario: Custom source_directory set
    Given a "config/custom_source_dir" exists
    And a "default.yml" file exists in the "config/custom_source_dir" directory
    When I set "source_directory" to "config/custom_source_dir"
    Then the "default.yml" file should be loaded from the "config/custom_source_dir" directory

  Scenario: Custom env_variable set
    Given a "CUSTOM_ENV_VAR" environment variable exists and is set to "env.yml"
    When I set "env_variable" to "CUSTOM_ENV_VAR"
    Then the "env.yml" file should be loaded from the default directory

  Scenario: Custom configuration options given
    Given I configure TestConfig with the following options
      | option           | value                    |
      | default_file     | custom_default.yml       |
      | source_directory | config/custom_source_dir |
      | env_variable     | CUSTOM_ENV_VAR           |
    And a "custom_default.yml" file exists in the "config/custom_source_dir" directory
    And a "CUSTOM_ENV_VAR" environment variable exists and is set to "env.yml"
    Then the "custom_default.yml" file should be loaded from the "config/custom_source_dir" directory
    And the "env.yml" file should be loaded from the "config/custom_source_dir" directory
