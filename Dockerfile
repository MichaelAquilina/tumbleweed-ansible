FROM opensuse:tumbleweed

RUN zypper install -y python-pip gnome-shell && \
    pip install ansible

COPY . /home/suse/tumbleweed-ansible
WORKDIR /home/suse/tumbleweed-ansible

RUN ansible-playbook -i local.inventory setup.yml
