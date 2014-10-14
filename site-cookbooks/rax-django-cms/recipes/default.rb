
case node['rax-django-cms']['database']['adapter']
when 'mysql'
  include_recipe 'mysql::client'
when 'postgresql_psycopg2'
  include_recipe 'postgresql::client'
when 'sqlite3'
  include_recipe 'sqlite'
end

node['rax-django-cms']['packages'].each do |pkg|
  package pkg
end

include_recipe "apache2::default"
include_recipe "apache2::mod_wsgi"

django_pkgs = node['rax-django-cms']['pip_packages']
dev_user = node['rax-django-cms']['username']
dev_group = node['rax-django-cms']['group']
workspace = node['rax-django-cms']['path']
project = node['rax-django-cms']['project_name']

user dev_user do
    password node['rax-django-cms']['password']
    supports :manage_home => true
    shell node['rax-django-cms']['shell']
    home node['rax-django-cms']['home']
    action :create
end

group dev_group do
    action :modify
    members node['apache']['user']
    append true
end

directory workspace do
    owner dev_user
    group dev_group
    mode 02775
    action :create
end

bash "create virtual environment #{workspace}" do
    code "su -c 'virtualenv #{workspace}' - #{dev_user}"
    not_if { ::File.exists?(File.join(workspace, 'bin', 'pip')) }
end

python_pip 'django' do
  virtualenv workspace
  user dev_user
  group dev_group
  version node['rax-django-cms']['django_version']
  action :install
end

node['rax-django-cms']['pip_packages'].each do |pkg|
  python_pip pkg do
    virtualenv workspace
    user dev_user
    group dev_group
    action :install
  end
end

bash 'create_django_project' do
    environment 'VIRTUAL_ENV' => workspace
    code "su -c 'cd #{workspace}; bin/python bin/django-admin.py startproject #{project}' - #{dev_user}"
    not_if { ::File.exists?(File.join(workspace, project, 'manage.py')) }
    action :run
end

# Put in base configuration and wsgi configuration
%w{ settings.py wsgi.py }.each do |f|
    template File.join(workspace, project, project, f) do
        source "#{f}.erb"
    end
end

# Add custom Apache wsgi configuration
apache_conf 'wsgi'

template File.join(workspace, project, project, 'urls.py') do
    source 'urls.py.erb'
    mode 0644
    owner dev_user
    group dev_group
end

directory File.join(workspace, project, project, 'templates') do
    owner dev_user
    group dev_group
    mode 02775
    action :create
end

# Install base templates
%w( base.html template_1.html ).each do |tmpl|
    template File.join(workspace, project, project, 'templates', tmpl) do
        source "#{tmpl}.erb"
        mode 0644
        owner dev_user
        group dev_group
    end
end

if node['rax-django-cms']['use_swift']
  include_recipe 'git'

  git File.join(Chef::Config[:file_cache_path], 'django-cumulus') do
    repository 'https://github.com/django-cumulus/django-cumulus.git'
    depth 1
    action :sync
  end

  directory File.join(Chef::Config[:file_cache_path], 'django-cumulus') do
    recursive true
    action :delete
    not_if { ::File.exists?(File.join(Chef::Config[:file_cache_path], 'django-cumulus', 'setup.py')) }
    notifies :sync, "git[#{File.join(Chef::Config[:file_cache_path], 'django-cumulus')}]", :immediately
  end

  python_pip File.join(Chef::Config[:file_cache_path], 'django-cumulus') do
    virtualenv workspace
    user dev_user
    group dev_group
    action :install
  end
end

bash 'syncdb' do
    environment 'VIRTUAL_ENV' => workspace
    code "su -c 'cd #{File.join(workspace, project)}; ../bin/python manage.py syncdb --all --noinput; ../bin/python manage.py migrate --fake' - #{dev_user}"
    action :run
end

bash 'create_django_superuser' do
    environment 'VIRTUAL_ENV' => workspace
    code <<-EOS
su -c 'cd #{File.join(workspace, project)}; echo "from django.contrib.auth.models import User; User.objects.create_superuser(\\"#{node['rax-django-cms']['django_admin_user']}\\", \\"#{node['rax-django-cms']['django_admin_email']}\\", \\"#{node['rax-django-cms']['django_admin_pass']}\\")" | ../bin/python manage.py shell' - #{dev_user}
    EOS
    action :run
end

bash 'collectstatic' do
    environment 'VIRTUAL_ENV' => workspace
    code "su -c 'cd #{File.join(workspace, project)}; ../bin/python manage.py collectstatic --noinput' - #{dev_user}"
    action :run
end

if node['rax-django-cms']['use_swift']
    bash 'container_create' do
        environment 'VIRTUAL_ENV' => workspace
        code "su -c 'cd #{File.join(workspace, project)}; ../bin/python manage.py container_create Django-CMS' - #{dev_user}"
        action :run
    end
end

web_app project do
    template 'apache.erb'
    apache_name node['apache']['package']
end
