FROM debian:bookworm-slim as base

RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    acl attr samba samba-ad-provision samba-dsdb-modules samba-vfs-modules winbind libpam-winbind libnss-winbind krb5-config krb5-user dnsutils python3-setproctitle \ 
    gettext-base chrony bind9 bind9utils rsync \
    && apt-get remove --purge --auto-remove -y

# Bind
RUN echo 'OPTIONS="-u bind -4"' > /etc/default/bind9 \
    # # This configures dynamically loadable zones (DLZ) from AD schema
    && echo 'dlz "AD DNS Zone" { database "dlopen /usr/lib/x86_64-linux-gnu/samba/bind9/dlz_bind9_16.so -d 3"; };' >> /etc/bind/named.conf.local

# Kerberos
# adjust permissions for bind
RUN chmod 644 /etc/krb5.conf \
    && chown root:bind /etc/krb5.conf

# Samba
RUN rm /etc/samba/smb.conf

FROM base

# templates
COPY templates/ /templates

# entrypoint
COPY --chmod=711 entrypoint/ /docker-entrypoint.d/
COPY --chmod=711 docker-entrypoint.sh /docker-entrypoint.sh
COPY --chmod=711 startup.sh /startup.sh
COPY --chmod=711 sync-sysvol.sh /sync-sysvol.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD ["/startup.sh"]