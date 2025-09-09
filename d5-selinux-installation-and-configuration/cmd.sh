sestatus # check if selinux's current config
sudo yum install -y policycoreutils selinux-policy selinux-policy-targeted # install the package
sudo yum install nano # install nano editor
sudo nano /etc/selinux/config # open the selinux config in nano editor
SELINUX=disabled # change the selinux to disabled
