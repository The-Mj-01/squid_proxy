FROM ubuntu/squid:latest

# نصب ابزارهای مورد نیاز
RUN apt-get update && apt-get install -y apache2-utils

# ایجاد فایل passwd با یک کاربر و رمز عبور
RUN htpasswd -c -b /etc/squid/passwd ramzinex 8G2xouWVAUU0

# کپی کردن فایل‌های پیکربندی
COPY squid.conf /etc/squid/squid.conf

# تنظیم دسترسی به فایل passwd
RUN chmod 640 /etc/squid/passwd && chown proxy:proxy /etc/squid/passwd

CMD ["-N"]
