FROM centos:8

#Default Variables # varibales from configmap will override these.
ENV WSGSITENAME="dev"
ENV WSGSERVER="dev.mediawiki.mydomain.com"
ENV WGDBSERVER="mediawiki-db"
ENV WGDBNAME="wikidatabase"
ENV WGDBUSER="wikiuser"
ENV WGDBPASSWORD="Changeme"

RUN dnf -y update
RUN dnf -y install httpd httpd-tools php php-mysqlnd php-gd php-xml mariadb php-mbstring php-json wget
COPY httpd.conf /etc/httpd/conf/httpd.conf
COPY 00-mpm.conf /etc/httpd/conf.modules.d/00-mpm.conf
WORKDIR /var/www
COPY mediawiki-1.31.10.tar.gz .
RUN tar -zxf mediawiki-1.31.10.tar.gz
RUN rm -f mediawiki-1.31.10.tar.gz
RUN ln -s mediawiki-1.31.10/ mediawiki
RUN mkdir /var/config
RUN ln -s /var/config/LocalSettings.php /var/www/mediawiki/LocalSettings.php
RUN chown -R apache:apache /var/www/mediawiki
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
EXPOSE 80

