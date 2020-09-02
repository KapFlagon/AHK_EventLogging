# EventLogging 
An Autohotkey Class for logging events in a plain text log file. 
## Prerequisites 
You must download the [TimeAndDateTool.ahk](https://github.com/KapFlagon/AHK_TimeAndDateTool) file. 
## How to use
1. Download the EventLogging.ahk file.
2. Place EventLogging.ahk in your local AHK library folder 
    - If you are not using a local AHK library folder, you can place EventLogging.ahk into the same folder as the script that is going to use the class. 
3. Insert an appropriate ["#Include"](https://www.autohotkey.com/docs/commands/_Include.htm) statement near the top of the .ahk script which will use the EventLogging.ahk class. 
4. Create an instance of the EventLogging class in your .ahk file, passing it the target directory for storing the logs.
    - `eventLogging := new EventLogging(targetDirectory)`
5. Use the instance to call class methods.
    - In this example, you can call this method to add an entry to the log file.
        - `eventLogging.addToLogFile(messageType, messageText)`