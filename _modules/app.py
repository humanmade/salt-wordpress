from subprocess import call
import sys, urllib, urllib2

def update():
	'''
	Update the app deployment

	CLI Example::

		salt '*' app.update
	'''

	args = ["cd /srv/www/webroot ; git pull ; git submodule foreach git fetch --tags ; git submodule update --init --recursive"]

	current_rev = __salt__['cmd.run']( "cd /srv/www/webroot ; git log --pretty=format:'%h %s' -n 1 | cat", runas=__grains__['user'], python_shell=True )
	current_rev_hash = __salt__['cmd.run']( "cd /srv/www/webroot ; git rev-parse HEAD", runas=__grains__['user'], python_shell=True )

	info         = __salt__['cmd.run']( ' '.join( args ), runas=__grains__['user'], python_shell=True )
	new_rev      = __salt__['cmd.run']( "cd /srv/www/webroot ; git log --pretty=format:'%h %s' -n 1 | cat", runas=__grains__['user'], python_shell=True )
	new_rev_hash = __salt__['cmd.run']( "cd /srv/www/webroot ; git rev-parse HEAD", runas=__grains__['user'], python_shell=True )
	changelog    = __salt__['cmd.run']( "cd /srv/www/webroot ; git log --pretty=oneline " + current_rev_hash + "...HEAD | cat", runas=__grains__['user'], python_shell=True )

	if new_rev == current_rev:
		return info

	data = {
		"new_rev": new_rev,
		"new_rev_hash": new_rev_hash,
		"changelog": changelog,
		"old_rev": current_rev,
		"old_rev_hash": current_rev_hash
	}

	return data

def version():

	return __salt__['cmd.run']( "cd /srv/www/webroot ; git log --pretty=format:'%h %s' -n 1 | cat", python_shell=True )

def status():

	return __salt__['cmd.run']( "cd /srv/www/webroot ; git status", python_shell=True )

def git(*argv, **kwargs):
	args = ["cd /srv/www/webroot ; git"]

	for arg in argv :
		if arg == ';' or arg == '&&' :
			continue

		args.append( arg )

	for key in kwargs:
		if key.startswith( '__' ) or key == ';' or key == '&&' :
			continue

		args.append( '--' + key + '=' + kwargs[key] )

	return __salt__['cmd.run']( ' '.join( args ), runas=__grains__['user'], python_shell=True )

def wp(*argv, **kwargs):

	args = ["cd /srv/www/webroot ; wp"]

	for arg in argv :
		if arg == ';' or arg == '&&' :
			continue

		args.append( arg )

	for key in kwargs:
		if key.startswith( '__' ) or key == ';' or key == '&&' :
			continue

		args.append( '--' + key + '=' + kwargs[key] )

	return __salt__['cmd.run']( ' '.join( args ), runas=__grains__['user'], python_shell=True )

def credentials():

	return { k: v for k, v in __grains__.items() if k.startswith('deployment_') }

def php_log():

	return __salt__['cmd.run']( 'tail /var/log/php.log', python_shell=True )

def access_log():

	return __salt__['cmd.run']( 'tail /var/log/nginx/access.log', python_shell=True )

def nginx_error_log():

	return __salt__['cmd.run']( 'tail /var/log/nginx/error.log', python_shell=True )


