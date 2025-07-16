sudo apt update && sudo apt install ufw -y
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw default deny incoming
sudo ufw enable
sudo ufw status verbose
