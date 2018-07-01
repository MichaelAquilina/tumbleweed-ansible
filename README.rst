Tumbleweed Ansible
==================

|TravisCI|

Setup an OpenSUSE Tumbleweed machine up from scratch.

::

    $ ansible-playbook -i local_inventory.yml setup.yml -K

Minimum version of ansible supported is 2.6

.. |TravisCI| image:: https://travis-ci.org/MichaelAquilina/tumbleweed-ansible.svg?branch=master
   :target: https://travis-ci.org/MichaelAquilina/tumbleweed-ansible
