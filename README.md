# CVSNT
[
](https://download.microsoft.com/download/8/8/0/880BCA75-79DD-466A-927D-1ABF1F5454B0/PBIDesktopSetup_x64.exe)test
#!/usr/bin/expect
set send_slow {1 0.02}
# set Variables
set hname [lrange $argv 0 0]
set appID [lrange $argv 1 1]
set fp [open "~/.ssh/mypassword" r]
set pass [read $fp]

#send_user "my pass is $pass"

close $fp

set timeout 40

set prompt "(.*(%|#|\\$|\\>) $)|(.*(%|#|\\$|>)$)"

catch {set prompt $env(EXPECT_PROMPT)}
spawn ssh jchen6@$hname

expect {
  "Are you sure you want to continue connecting (yes/no)? " {
    send "yes\r"
    expect -re ".*assword: $" {
      send -s "$pass\r"
    }
  }
  -re ".*(P|p)assword: $" {
    send -s "$pass\r"
  }
  default { exit 2 }
  eof{
   send_user "# $hname is not available" 
  }
}
Ω
# Check pbrun

#expect  -re "$prompt" {
#  send "if \[\[ `uname -s` = \"Linux\" \]\]; then sudo -l ; fi\r"
#}


expect  -re "$prompt" {
  send "pbrun rights\n"
}

sleep 1

if { $appID ne "" } {

  expect {
    -re "$prompt" {
      send  "sudo su - $appID\r"
      #send  "pbsu $appID\r"
      #send  "pbsu - $appID\r"
    }
    -re ".*assword: $" {
      send_user "\n## User name or password on $hname is not correct.\n"
      exit 1
    }
  }
  
  expect {
    -re "(Password: $)|(Password:$)" {
      send "\032\r"

      expect -re "$prompt" { send  "pbsu - $appID\r" }
      #send  "sudo su - $appID\r"
      expect -re "$prompt" { send "id\n" }
      }
   -re ".*not allowed.*" { send  "pbsu - $appID\r" }
   -re "$prompt" { send "id\n" }
   }
  
    expect -re "$prompt"
    send "bash\r"
    

    expect -re "$prompt"
    send "TMOUT=36000\r"

    expect -re "$prompt"
    send "export TMOUT\r"

    expect -re "$prompt"
    send "TIMEOUT=36000\r"
    
    expect -re "$prompt"
    send "export TIMEOUT\r" 

    expect -re "$prompt"
    send "if \[\[ `uname -s` = \"Linux\" \]\]; then stty erase ^? ; else set -o vi; stty erase ^H; fi\r"

    expect -re "$prompt"
    send "ulimit -n\r"

     #expect -re "$prompt"
     #send "eval `resize`\r"
     # send "stty rows 56 columns 126 ; eval `resize`\r"
     #send "stty rows 56 columns 126\r"
   

}

interact
