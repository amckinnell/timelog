Timelog Refactoring Exercise

Slight modification to the timelog exercise from
Chapter 16 of [Refactoring In Ruby](http://www.informit.com/store/refactoring-in-ruby-9780321545046)

#### Exercise 16.1 Rewrite or Refactor?

Look at the tool's code. We need to replace it with a version that uses a
different persistence mechanism, but which otherwise has the same features.

  * What are the arguments for and against refactoring the existing script?
  * Make a list of the script's smells.

#### Exercise 16.2 Project Kick-Off

  * Take whatever time you need to set up your development project for this
  exercise and run the tests.
  * Take a moment to develop a strategy for this refactoring task, think about
  the steps you might take in order to accomplish it safely, without leaving
  anything broken.

#### Exercise 16.3 Test Coverage

  * Review the existing tests and identify areas where coverage is weak.
  (Concentrate on looking at the application as a "black box"; try not to be
  sidetracked by the code itself.)
  * Write the missing tests;f for consistency, adopt the style and approach of
  the existing tests.

#### Exercise 16.4 Application Object

  * Use _Extract Class_ to create a new class representing the timelog
  application. Give the new class a constructor taking the file's name as a
  parameter.
  * Move the ```report``` and ```log``` methods over to the new class.
  * Refactor the tests to use those new methods. Is the environment variable
  needed now?
  * That last change lost us some test coverage. Is that a problem? What would
  you do about it?

#### Exercise 16.5 Testable Methods

  * Remove duplication in the tests by extracting more fine-grained and specific
  methods on the application object. (Hint: You will create half a dozen methods
  such as ```total_hours_for(project)```.)

#### Exercise 16.6 Rates of Change

  * Look at the methods that contain code for reading or writing the file. Split
  each of these methods apart, so that report formatting is separated from the
  file operations.
  * Use _Extract Class_ on your application object to wrap the file methods
  together with the path to the file.
  * Refactor the application's object so that its parameter is a whole
  ```TimelogFIle``` instance by pushing the ```TimelogFile``` 's construction
  up into the tests and the top-level script. This deliberately introduces a
  little duplication; what are the mitigating factors in this case?

#### Exercise 16.7 Open Secrets

  * Fix these open secrets by introducing a new class to wrap the SCV strings.
  Look for opportunities to move code into the new class. Can ypou use the new
  class to simplify any of the tests?
