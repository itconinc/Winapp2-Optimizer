Winapp2-Optimizer
=================

To keep only what your configuration needs from CCleaner's "Winapp2.ini":

1. Put your downloaded "[Winapp2.ini]" file in the same folder as "Winapp2Optimizer.ps1",
2. Execute "Winapp2Optimizer.sp1" by right-clicking on it: "Execute with PowerShell",
3. It's done, your "Winapp2.ini" file has been edited and optimized.

N.B.: By default, Windows does not allow PowerShell script running. Here is what you have to do:

1. Open PowerShell in "Start Menu => Accessories => Windows PowerShell => Windows PowerShell.lnk",
2. Enter the following command: 
	```
	Set-ExecutionPolicy RemoteSigned
	```
	You can revert it back with:
	```
	Set-ExecutionPolicy Restricted
	```
3. Validate the authorization process by entering "Y" for yes,
4. It's done, you can now run PowerShell scripts on your system.

Enjoy!

Julien Lacroix & Yann Prime
