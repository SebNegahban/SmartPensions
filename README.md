## Usage
Run `bundle install` to install the necessary gem dependencies.
Then `./script/parser.rb <path_to_log_file>` to run the log file parser.
The output from the parser will be put into the console window, and will be separated into two categories:
* Total views
* Unique views
Both of which will be sorted in descending order of the most number of views per page.

## Development
There are four main areas of the program:
* The initial `parser` script which handles booting the program
* A Log Parser which reads the log and aggregates the views
* A Log Formatter which formats the output to the console
* A custom exception class, LogError

LogError was created to prevent other unexpected errors from being unintentionally caught.

Rubocop has been installed to aid with linting. There are some known issues, including a couple of methods and blocks deemed too long,
and a few lines with too many characters. It was deemed that these were acceptable 'issues' and that by 'fixing' them as rubocop recommended,
it would make the code less readable and add unnecessary method calls.

## Testing
Automated tests are written with RSpec and can be run using `bundle exec rspec spec <optional_path_to_spec>`
Coverage is checked using SimpleCov and can be viewed after running `bundle exec rspec spec` in the `coverage` directory.

## Future development
If I were to continue developing this project, the next big ugrade would likely be creating a UI rather than relying on CLI output.

Smaller improvements would include:
* Wider acceptance of input/ more variable validations, to allow log files of different formats to be parsed
* More detailed feedback on the quality of the data in the log file (eg 3 lines skipped due to missing IP Addresses).
* Adding a level of performance monitoring with extremely large log files.

More detailed feedback on the quality of the data in the log file was not given now as I was concerned that it would make the CLI
output less clear in its response. With a custom UI it would be much easier to give extra information without taking focus away from
the primary output.
