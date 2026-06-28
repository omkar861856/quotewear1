#!/usr/bin/expect -f
set timeout -1
set IP "187.127.133.157"
set USER "root"
set PASS "2Z,LD79(rurJBrHH"
set LOCAL_DIR "/Users/omkardlolge/Desktop/medusa/"
set REMOTE_DIR "/root/medusa"

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
spawn ssh -o ServerAliveInterval=15 -o StrictHostKeyChecking=no $USER@$IP {
    cd /root/medusa
    
    sudo docker compose up -d --build backend proxy
    sleep 40
    sudo docker compose run --rm backend yarn seed
    
    # Extract the new publishable API key
    NEW_KEY=$(sudo docker compose exec -T postgres psql -U postgres -d medusa-db -t -c "SELECT token FROM api_key LIMIT 1;" | xargs)
    if [ ! -z "$NEW_KEY" ]; then
        echo "Found new publishable key: $NEW_KEY"
        sed -i "s/NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=.*/NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=$NEW_KEY/" .env
    fi

    sudo docker compose build storefront
    sudo docker compose up -d storefront
}
expect {
    "password:" {
        send "$PASS\r"
        exp_continue
    }
    eof
}
