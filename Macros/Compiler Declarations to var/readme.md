# Compiler directives to var
Using the var keyword to declare variables looks much nicer than using compiler directives:

var $name; $firstName: Text
var $age: Integer

instead of

C_TEXT($name; $firstName)
C_LONGINT($age)

After having changed many declarations manually, I though it's time to automate this process. To use it, simply add the compilerDirectivesToVar and macroCompilerDirectivesToVar methods to your project and the Macros Compiler Directives to var.xml to your macros folder (or add the content to your macro file). You can then select part of your code and click "Change to var-syntax" in ther macros menu to automatically change any C_-Declarations to the var-syntax. If you do not select code then the entire method will be modified.

USE AT YOUR OWN RISK!
