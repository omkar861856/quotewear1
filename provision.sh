#!/usr/bin/expect -f
set timeout -1
set IP "187.127.133.157"
set USER "root"
set PASS "2Z,LD79(rurJBrHH"

# Step 1: Install Docker and Certbot
spawn ssh -o StrictHostKeyChecking=no $USER@$IP {
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install -y ca-certificates curl gnupg lsb-release expect
    
    # Install Docker
    if ! command -v docker &> /dev/null; then
        echo "Installing Docker..."
        mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
        apt-get update -y
        apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    fi
    
    # Install Certbot
    if ! command -v certbot &> /dev/null; then
        echo "Installing Certbot..."
        apt-get install -y certbot
    fi
    
    echo "Setup Complete!"
}
expect {
    "password:" {
        send "$PASS\r"
        exp_continue
    }
    eof
}
