#!/usr/bin/expect -f
set timeout -1
set IP "187.127.133.157"
set USER "root"
set PASS "2Z,LD79(rurJBrHH"

spawn ssh -o StrictHostKeyChecking=no $USER@$IP "certbot certonly --standalone -d quotewear.store -d www.quotewear.store -d admin.quotewear.store --non-interactive --agree-tos -m admin@quotewear.store"
expect {
    "password:" {
        send "$PASS\r"
        exp_continue
    }
    eof
}
