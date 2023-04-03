FROM fedora

RUN dnf install -y \
        ansible ansible-collection-community-general \
        dbus-daemon

COPY . /home/fedora/tumbleweed-ansible
WORKDIR /home/fedora/tumbleweed-ansible

RUN ansible-playbook setup.yml
