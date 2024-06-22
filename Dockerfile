FROM ubuntu/squid:latest

# نصب ابزارهای مورد نیاز
RUN apt-get update && apt-get install -y apache2-utils openssl squid-openssl

# ایجاد دایرکتوری برای گواهینامه‌ها
RUN mkdir -p /etc/squid/ssl_cert

# ایجاد کلید خصوصی و گواهینامه
RUN openssl genrsa -out /etc/squid/ssl_cert/squidCA.key 4096 && \
    openssl req -new -key /etc/squid/ssl_cert/squidCA.key -out /etc/squid/ssl_cert/squidCA.csr -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost" && \
    openssl x509 -req -days 3650 -in /etc/squid/ssl_cert/squidCA.csr -signkey /etc/squid/ssl_cert/squidCA.key -out /etc/squid/ssl_cert/squidCA.crt && \
    cat /etc/squid/ssl_cert/squidCA.crt /etc/squid/ssl_cert/squidCA.key > /etc/squid/ssl_cert/squidCA.pem

# ایجاد فایل htpasswd
RUN htpasswd -c -b /etc/squid/passwd username password

# کپی فایل پیکربندی squid.conf
COPY squid.conf /etc/squid/squid.conf

# تنظیم مجوزها
RUN chmod 640 /etc/squid/passwd && chown proxy:proxy /etc/squid/passwd
RUN chmod 644 /etc/squid/ssl_cert/squidCA.pem

CMD ["-N"]
