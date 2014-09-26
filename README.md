Winapp2-Optimizer
=================

To keep only what your configuration needs from CCleaner's "Winapp2.ini":

1. Put your downloaded [Winapp2.ini](http://winapp2.com/Winapp2.ini) file in the same folder as [Winapp2Optimizer.ps1](Winapp2Optimizer.ps1),
2. Right-click on [Winapp2Optimizer.ps1](Winapp2Optimizer.ps1), then click on "Execute with PowerShell",
3. It's done, your Winapp2.ini file has been edited and optimized.

N.B.: By default, Windows does not allow PowerShell script running. Here is what you have to do:

1. Open Start Menu > All Programs > Accessories > Windows PowerShell > Windows PowerShell,
2. Enter the following command: ```Set-ExecutionPolicy RemoteSigned```. You can revert it back with: ```Set-ExecutionPolicy Restricted```,
3. Validate the authorization process by entering "Y" for Yes,
4. It's done, you can now run PowerShell scripts on your system.

As a bonus, we included [CCleaner.reg](CCleaner.reg) in this project. It contains *Exclude* registry keys that prevent any unwanted cleaning (at least in our opinion) and one *Include* registry key that cleans Windows Update cache.

Enjoy!

Julien Lacroix & Yann Prime
