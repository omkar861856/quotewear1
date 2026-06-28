#!/usr/bin/expect -f
set timeout -1
set IP "43.166.254.141"
set USER "ubuntu"
set PASS "JQkXe7jfZ}]z^}TEPopXr+r"
set LOCAL_DIR "/Users/omkardlolge/Desktop/medusa/"
set REMOTE_DIR "/home/ubuntu/medusa"

# Step 1: Create the directory on the remote server
spawn ssh -o StrictHostKeyChecking=no $USER@$IP "mkdir -p $REMOTE_DIR"
expect {
    "password:" {
        send "$PASS\r"
        exp_continue
    }
    eof
}

# Step 2: Rsync the files
spawn rsync -avz --exclude "node_modules" --exclude ".next" --exclude ".git" -e "ssh -o StrictHostKeyChecking=no" $LOCAL_DIR $USER@$IP:$REMOTE_DIR
expect {
    "password:" {
        send "$PASS\r"
        exp_continue
    }
    eof
}

# Step 3: Run docker-compose
spawn ssh -o ServerAliveInterval=15 -o StrictHostKeyChecking=no $USER@$IP "cd $REMOTE_DIR && sudo grep -q 'admin.quotewear.store' /etc/hosts || echo '127.0.0.1 admin.quotewear.store' | sudo tee -a /etc/hosts && sudo grep -q 'quotewear.store' /etc/hosts || echo '127.0.0.1 quotewear.store' | sudo tee -a /etc/hosts && sudo docker compose up -d --build backend proxy && sleep 40 && sudo docker compose run --rm backend yarn seed && sudo docker compose build storefront && sudo docker compose up -d storefront"
expect {
    "password:" {
        send "$PASS\r"
        exp_continue
    }
    eof
}
