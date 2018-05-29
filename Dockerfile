FROM opensuse:tumbleweed

RUN zypper install -y python-pip gnome-shell git && \
    pip install git+https://github.com/ansible/ansible.git

COPY . /home/suse/tumbleweed-ansible
WORKDIR /home/suse/tumbleweed-ansible

RUN ansible-playbook -i local.inventory setup.yml
