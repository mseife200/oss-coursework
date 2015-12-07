semanage fcontext -a -t httpd_sys_content_t "/var/newwww/file.html"
restorecon -R -v /var/ newwww