#!/usr/bin/expect -f
set timeout -1
set IP "187.127.133.157"
set USER "root"
set PASS "2Z,LD79(rurJBrHH"
set cmd [lindex $argv 0]

spawn ssh -o StrictHostKeyChecking=no $USER@$IP "$cmd"
expect {
    "password:" {
        send "$PASS\r"
        exp_continue
    }
    eof
}
