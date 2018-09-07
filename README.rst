Tumbleweed Ansible
==================

|CircleCI|

Setup an OpenSUSE Tumbleweed machine up from scratch.

::

    $ ansible-playbook -i local_inventory.yml setup.yml -K

Minimum version of ansible supported is 2.6

.. |CircleCI| image:: https://codecov.io/gh/MichaelAquilina/tumbleweed-ansible/branch/master/graph/badge.svg
   :target: https://travis-ci.org/MichaelAquilina/tumbleweed-ansible
