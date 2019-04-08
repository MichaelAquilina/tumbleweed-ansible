FROM opensuse/tumbleweed

RUN zypper install -y python-pip && \
    pip install ansible==2.6.0

COPY . /home/suse/tumbleweed-ansible
WORKDIR /home/suse/tumbleweed-ansible

RUN ansible-playbook -i local.inventory setup.yml
