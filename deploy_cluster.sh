# rm -rf .terr* terr* *out 
# . ~/cert/.config_terraform.sh 
# terraform init && terraform plan --out=plan.out && terraform apply plan.out
terraform output --raw private_key_value > file 
chmod go-rwx file
ipaddress=$(terraform output  --raw jumphost_ip_address)
sed  -i -e "/jumphost/,/^$/{s#^    Hostname.*#    Hostname $ipaddress  #}" ~/.ssh/config 

