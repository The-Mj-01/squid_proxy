FROM ubuntu/squid:latest

# نصب ابزارهای مورد نیاز
RUN apt-get update && apt-get install -y apache2-utils openssl

# ایجاد دایرکتوری برای گواهینامه‌ها
RUN mkdir -p /etc/squid/ssl_cert

# ایجاد گواهینامه‌ها
RUN openssl genrsa -out /etc/squid/ssl_cert/squidCA.pem 4096 && \
    openssl req -new -x509 -key /etc/squid/ssl_cert/squidCA.pem -out /etc/squid/ssl_cert/squidCA.crt -days 3650 -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost" && \
    cat /etc/squid/ssl_cert/squidCA.pem /etc/squid/ssl_cert/squidCA.crt > /etc/squid/ssl_cert/squidCA.pem

# ایجاد فایل htpasswd
RUN htpasswd -c -b /etc/squid/passwd username password

# کپی فایل پیکربندی squid.conf
COPY squid.conf /etc/squid/squid.conf

# تنظیم مجوزها
RUN chmod 640 /etc/squid/passwd && chown proxy:proxy /etc/squid/passwd

CMD ["-N"]
