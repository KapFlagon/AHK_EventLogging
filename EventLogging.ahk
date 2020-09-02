; ***** Script Settings ***** ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\...\TimeAndDateTool.ahk


; ***** Class Definition ***** ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

class EventLogging {


  ; *****Class Variables ***** ;
  containerDirectory := ""
  logDirectory := ""
  logFileName := ""
  fullLogFilePath := ""
  timeAndDateTool := ""
  
  
  ; *****Class Constructor ***** ;
  __New(passedContainerDirectory) {
    ; Init variables
    this.timeAndDateTool := new TimeAndDateTool()
    this.containerDirectory := passedContainerDirectory
    this.updateDerivativeVariables()
    this.checkDirectoryAndFiles()
  }
  
  
  ; ***** Functions ***** ;
  getContainerDirectory() {
    return this.containerDirectory
  }
  
  getLogDirectory() {
    return this.logDirectory
  }
  
 getLogFileName() {
   return this.logFileName
 }
 
  getFullLogFilePath() {
    return this.fullLogFilePath
  }
  
  
  updateDerivativeVariables() {
    this.logDirectory := this.generateLogDirectory(this.containerDirectory)
    this.logFileName := this.generateLogfileName(this.containerDirectory)
    this.fullLogFilePath := this.logDirectory . "\" . this.logFileName
  }
  
  checkDirectoryAndFiles() {
    if !(this.logDirectoryExists()) {
      this.createLogDirectory()
    }         
    if !(this.logFileExists()) {
      this.createLogFile()
    } else {
      logMessage := "Log file re-accessed for continued use..."
      this.addToLogFile("Info", logMessage)
    }
  }
  
  generateLogfileName(passedContainerDirectory) {
    tempLogfileName := ""
    FormatTime, tempLogfileName, %A_Now%, dd_MM_yyyy_dddd
    tempLogfileName := tempLogfileName . ".tlog"
    return tempLogfileName
  }
    
    
  generateLogDirectory(passedContainerDirectory) {
    tempLogDirectory := ""
    FormatTime, tempLogDirectory, %A_Now%, yyyy\MMM
    tempLogDirectory := passedContainerDirectory . "\logs\" . tempLogDirectory
    ;this.logDirectory := tempLogDirectory
    return tempLogDirectory
  }
  
  
  logDirectoryExists() {
    if FileExist(this.logDirectory) {
      return true
    } else {
      return false
    }
  }
  
  
  createLogDirectory() {
    ; Logging here may be impractical, as the directories may not exist yet, nor the files. 
    ;addToLogFile("Info", "Creating Log directories...")
    tempDirectoryVar := this.logDirectory
    FileCreateDir, %tempDirectoryVar%
    if ErrorLevel {
      ;addToLogFile("Error", "Log directory creation failed!")
      MsgBox, There was an error while attempting to create the log file directories. `nPlease create a 'log' folder which contains a sub-folder for the current year. `nThe year sub-folder must contain another sub-folder for the current month, using a three character name.`nE.G. logs\2020\Jun
    } else {
      ;addToLogFile("Info", "Log File directories successfully created.")
    }
  }
  
  
  logFileExists() {
    if FileExist(this.fullLogFilePath) {
      return true 
    } else {
      return false
    }
  }
  
  
  createLogFile() {
    ;addToLogFile("Info", "Creating Log file...")
    tempFilePath := this.fullLogFilePath
    FileAppend, , %tempFilePath%
    
    if ErrorLevel {
      ;addToLogFile("Error", "Log File creation failed!")
      MsgBox, There was an error while attempting to create the log file. Logging will be disabled if you continue to use the script. Please restart the script to ensure logging is active. 
    } else {
      ;addToLogFile("Info", "Log File successfully created.")
    }
  }
  
  
  addToLogFile(messageType, messageText) {
    timeStamp := this.timeCalculator.generateTimestamp()
    logMessage := timeStamp . "`t|`t" . messageType . "`t|`t" . messageText . "`n"
    tempFullLogFilePath := this.fullLogFilePath
    FileAppend, %logMessage%, %tempFullLogFilePath%
  }
 
  
  getLogFileContents() {
    fullFileContent := ""
    this.addToLogFile("Info", "Reading log file contents...")
    tempFullLogFilePath := this.fullLogFilePath
    FileRead, fullFileContent, %tempFullLogFilePath%
    if ErrorLevel {
      logMessage := "Error reading log file contents! Code: " . %A_LastError%
      this.addToLogFile("Error", logMessage)
      MsgBox, Error while reading existing log file content. Code: %A_LastError%
      return A_LastError
    } else {
      return fullFileContent
    }
  }
  
  
  openLogfileFolder() {
    tempLogDirectory := this.logDirectory
    run, %tempLogDirectory%
  }
  
  
  openCurrentLogfile() {
    tempFullLogFilePath := this.fullLogFilePath
    run, %tempFullLogFilePath%
  }
  
 
}
  