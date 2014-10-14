Description
===========

Heat template to deploy a load balancer, multiple servers running Django CMS
on Django v1.6.x, and a Cloud Database


Requirements
============
* A Heat provider that supports the following:
  * OS::Nova::KeyPair
  * OS::Heat::RandomString
  * Rackspace::Cloud::LoadBalancer
  * OS::Heat::ResourceGroup
  * OS::Trove::Instance
* An OpenStack username, password, and tenant id.
* [python-heatclient](https://github.com/openstack/python-heatclient)
`>= v0.2.8`:

```bash
pip install python-heatclient
```

We recommend installing the client within a [Python virtual
environment](http://www.virtualenv.org/).

Parameters
==========
Parameters can be replaced with your own values when standing up a stack. Use
the `-P` flag to specify a custom parameter.

* `server_hostname`: Host name to give the servers provisioned (Default:
  django-%index%)
* `project_name`: The name to use to create your Django project. (Default:
  mysite)
* `app_name`: The name of your Django application. (Default: myapp)
* `db_flavor`: Required: Rackspace Cloud Database Flavor. Size is based on
  amount of RAM for the provisioned instance. (Default: 1GB Instance)
* `image`: Required: Server image used for all servers that are created as a
  part of this deployment. (Default: Ubuntu 12.04 LTS (Precise Pangolin))
* `load_balancer_hostname`: Hostname for the Load Balancer (Default:
  Django-Load-Balancer)
* `venv_username`: Username with which to login to the Linux servers. This user
  will be the owner of the Python Virtual Environment under which Django is
  installed. (Default: pydev)
* `db_size`: Database instance size, in GB. min 10, max 150 (Default: 10)
* `flavor`: Required: Rackspace Cloud Server flavor to use. The size is based
  on the amount of RAM for the provisioned server. (Default: 4 GB Performance)
* `server_count`: Number of servers to deploy (Default: 2)
* `kitchen`: URL for the kitchen to use, fetched using git (Default:
  https://github.com/rackspace-orchestration-templates/django-cms-clouddb)
* `datastore_version`: Required: Version of MySQL to run on the Cloud Databases
  instance. (Default: 5.6)
* `child_template`: Location of child template (Default:
  https://raw.githubusercontent.com/rackspace-orchestration-templates/django-cms-clouddb/master/django-cms-single.yaml)
* `db_user`: Required: Username for the database. (Default: db_user)
* `django_admin_email`: Email address (Default: admin@example.com)
* `django_admin_user`: Administrative username for logging into Django.
  (Default: djangouser)
* `chef_version`: Version of chef client to use (Default: 11.14.6)

Outputs
=======
Once a stack comes online, use `heat output-list` to see all available outputs.
Use `heat output-show <OUTPUT NAME>` to get the value of a specific output.

* `private_key`: SSH Private Key
* `load_balancer_ip`: Load Balancer IP
* `server_ips`: Server IPs
* `db_user`: Database Username
* `django_url`: Django CMS URL
* `db_pass`: Database User Password
* `db_name`: Database Name
* `db_host`: Database Host
* `django_admin_user`: Django Admin User
* `django_admin_pass`: Django Admin Password

For multi-line values, the response will come in an escaped form. To get rid of
the escapes, use `echo -e '<STRING>' > file.txt`. For vim users, a substitution
can be done within a file using `%s/\\n/\r/g`.

Stack Details
=============
#### Getting Started
As soon as the deployment finishes building, you can access your site by
hitting the Django CMS URL in the outputs section. From the Django CMS
default home page there will be a link to go into edit mode which will pop up
a login prompt at the top of your browser. Use the Django Admin User and
Password provided in the outputs to login to begin managing your site.

#### Details of Your Setup
This deployment was stood up using
[chef-solo](http://docs.opscode.com/chef_solo.html). Once the deployment is
up, chef will not run again, so it is safe to modify configurations.

A system user of 'pydev' has been created. This user has owns the [Virtual
Environment](http://virutalenv.org) setup in '/srv/workspace'. If you need to
install additional packages with pip, run 'source
/srv/workspace/bin/activate' as the 'pydev' user prior to running 'pip
install'.

The Django CMS can be found in '/srv/workspace/mysite'. All installed
applications and settings can be found in 'mysite/settings.py'.

Django CMS as of v3.0.5 only officially supports Django v1.6.x. Once Django v1.7
is officially supported we will migrate this deployment to Django v1.7.

The CMS is served by [Apache](http://httpd.apache.org/) leveraging
[mod_wsgi](http://www.modwsgi.org/). The mod_wsgi configuration can be found
in '/etc/apache2/mods-available/wsgi.conf', and the Apache site configuration
can  be found within '/etc/apache2/sites-available/mysite.conf'. Any changes
to configuration files will require Apache to be restarted or reloaded.

#### Logging In via SSH
The Linux user provided with this deployment will provide you SSH access to
your servers. This user will have sudo access to gain root access.
Alternatively, the private key provided in the passwords section can be used
to login as root via SSH. We have an article on how to use these keys with
[Mac OS X and
Linux](http://www.rackspace.com/knowledge_center/article/logging-in-with-a-ssh-private-key-on-linuxmac)
as well as [Windows using
PuTTY](http://www.rackspace.com/knowledge_center/article/logging-in-with-a-ssh-private-key-on-windows).

Contributing
============
There are substantial changes still happening within the [OpenStack
Heat](https://wiki.openstack.org/wiki/Heat) project. Template contribution
guidelines will be drafted in the near future.

License
=======
```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
