# System user settings
default['rax-django-cms']['project_name'] = 'django-cms'
default['rax-django-cms']['username'] = 'pydev'
default['rax-django-cms']['password'] = '$6$AeDhp6NK$.fdGSdTJ/ibAF.OdqU4HoOmGE1Ht7hyV7MB862vmT2vABqwLMruuftTcmZdZlbSZIOTJypDnTy7pmpkh50jQw0'
default['rax-django-cms']['group'] = node['rax-django-cms']['username']
default['rax-django-cms']['shell'] = '/bin/bash'
default['rax-django-cms']['home'] = File.join('/home', node['rax-django-cms']['username'])

# Django settings
#  django-cms only support django 1.6.x at present. 
default['rax-django-cms']['django_version'] = '1.6.7'
default['rax-django-cms']['django_admin_user'] = 'admin'
default['rax-django-cms']['django_admin_email'] = 'admin@example.com'
default['rax-django-cms']['django_admin_pass'] = 'dj4ng0p4ss'

default['rax-django-cms']['path'] = '/srv/workspace'  # venv setup here
default['rax-django-cms']['secret_key'] = 'suchS3cr3t5'

default['rax-django-cms']['packages'] = %w()  # OS Packages
default['rax-django-cms']['pip_packages'] = %w(pillow
                                               mysql-python
                                               django-cms
                                               djangocms_file
                                               djangocms_flash
                                               djangocms_googlemap
                                               djangocms_link
                                               djangocms_picture
                                               djangocms_snippet
                                               djangocms_teaser
                                               djangocms_video
                                               djangocms_twitter)

# Database Settings
default['rax-django-cms']['database']['host'] = 'localhost'
# For supported database adapters, see:
#   https://docs.djangoproject.com/en/dev/ref/settings/#engine
default['rax-django-cms']['database']['adapter'] = 'mysql'
default['rax-django-cms']['database']['name'] = 'django_cms'
default['rax-django-cms']['database']['user'] = 'django'
default['rax-django-cms']['database']['password'] = 'djangopass'
default['rax-django-cms']['database']['port'] = ''

# Swift settings if using Cumulus
default['rax-django-cms']['use_swift'] = false
default['rax-django-cms']['swift']['user'] = ''
default['rax-django-cms']['swift']['api_key'] = ''
default['rax-django-cms']['swift']['region'] = 'iad'
