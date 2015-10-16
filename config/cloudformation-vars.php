<?php

defined( 'DB_HOST' ) or define( "DB_HOST", "{{ grains['deployment_mysql_hostname'] }}" );
{% if grains['deployment_mysql_slave_hostname'] == 'None' %}
defined( 'DB_HOST_SLAVE' ) or define( "DB_HOST_SLAVE", "" );
{% else %}
defined( 'DB_HOST_SLAVE' ) or define( "DB_HOST_SLAVE", "{{ grains['deployment_mysql_slave_hostname'] }}" );
{% endif %}
defined( 'DB_PASSWORD' ) or define( "DB_PASSWORD", "{{ grains['deployment_mysql_password'] }}" );
defined( 'DB_NAME' ) or define( "DB_NAME", "{{ grains['deployment_mysql_db_name'] }}" );
defined( 'DB_USER' ) or define( "DB_USER", "{{ grains['deployment_mysql_username'] }}" );

{% if grains['deployment_s3_uploads_path'] != 'None' %}
	defined( 'S3_UPLOADS_BUCKET' ) or define( 'S3_UPLOADS_BUCKET', "{{ grains['deployment_s3_uploads_bucket'] }}/{{ grains['deployment_s3_uploads_path'] }}" );
{% else %}
	defined( 'S3_UPLOADS_BUCKET' ) or define( 'S3_UPLOADS_BUCKET', "{{ grains['deployment_s3_uploads_bucket'] }}" );
{% endif %}
defined( 'S3_UPLOADS_KEY' ) or define( 'S3_UPLOADS_KEY', "{{ grains['deployment_s3_uploads_access_key'] }}" );
defined( 'S3_UPLOADS_SECRET' ) or define( 'S3_UPLOADS_SECRET', "{{ grains['deployment_s3_uploads_secret_key'] }}" );

{% if grains['deployment_elasticsearch_hostname'] != 'None' %}
define( 'ELASTICSEARCH_HOST', '{{ grains['deployment_elasticsearch_hostname'] }}');
define( 'ELASTICSEARCH_PORT', {{ grains['deployment_elasticsearch_port'] }} );
{% endif %}

defined( 'HM_ENV' ) or define( 'HM_ENV', "{{ grains['project'] }}" );

global $memcached_servers;

if ( empty( $memcached_servers ) ) {
	$memcached_servers = array( "{{ grains['deployment_memcached_hostname'] }}:{{ grains['deployment_memcached_port'] }}" );	
}
