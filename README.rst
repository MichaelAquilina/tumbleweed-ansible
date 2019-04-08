Tumbleweed Ansible
==================

|CircleCI|

Setup an OpenSUSE Tumbleweed machine up from scratch.

::

    $ ansible-playbook -i local_inventory.yml setup.yml -K

Minimum version of ansible supported is 2.6
.. |CircleCI| image:: https://circleci.com/gh/MichaelAquilina/tumbleweed-ansible.svg?style=svg
   :target: https://circleci.com/gh/MichaelAquilina/tumbleweed-ansible
