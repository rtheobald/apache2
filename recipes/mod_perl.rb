#
# Cookbook:: apache2
# Recipe:: mod_perl
#
# adapted from the mod_python recipe by Jeremy Bingham
#
# Copyright:: 2008-2017, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform_family']
when 'debian'
  package %w(libapache2-mod-perl2 libapache2-request-perl)

  if node['platform'] == 'debian' && node['platform_version'].to_f <= 8
    package 'apache2-mpm-prefork'
  end
when 'suse'
  with_run_context :root do
    package 'apache2-mod_perl' do
      notifies :run, 'execute[generate-module-list]', :immediately
    end
  end

  package 'perl-Apache2-Request'
when 'rhel', 'fedora', 'amazon'
  with_run_context :root do
    package 'mod_perl' do
      notifies :run, 'execute[generate-module-list]', :immediately
    end
  end

  package 'perl-libapreq2'
when 'freebsd'
  package %w( ap24-mod_perl2 p5-libapreq2)
end

file "#{apache_dir}/conf.d/perl.conf" do
  content '# conf is under mods-available/perl.conf - apache2 cookbook\n'
  only_if { ::Dir.exist?("#{apache_dir}/conf.d") }
end

apache2_module 'perl'
