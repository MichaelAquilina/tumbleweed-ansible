FROM opensuse:tumbleweed

RUN zypper install -y python-pip gnome-shell git && \
    pip install https://github.com/ansible/ansible/archive/v2.6.0a2.tar.gz

COPY . /home/suse/tumbleweed-ansible
WORKDIR /home/suse/tumbleweed-ansible

RUN ansible-playbook -i local.inventory setup.yml
