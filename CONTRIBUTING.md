# Contributing
Contributions are more than welcome. Please keep changes related to adding new features, and bug fixes. Please refain from submitting only formatting, whitespace changes. Any pull request primarily consisting of these kinds of changes will closed and not merged. Do not change project settings and configuration. These changes are very hard to understand in a pull request. If it is desired to change the configuration please open an issue.

# Linux Users
If you are using Linux and want to run the tests you must first generate all the test cases.
In terminal navigate to the `Scripts/` folder. Run `./TestCaseGen.py`. This generates all necessary files to run the tests on Linux. These files are not in source control. I don't want to manage these files, so when someone in Xcode adds a new test they dont have to remember to update anything.
