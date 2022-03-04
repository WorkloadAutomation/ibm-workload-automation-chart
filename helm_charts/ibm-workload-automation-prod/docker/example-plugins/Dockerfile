####################################################################
# Licensed Materials Property of HCL*
# (c) Copyright HCL Technologies Ltd. 2021. All rights reserved.
#
# * Trademark of HCL Technologies Limited
####################################################################
FROM registry.access.redhat.com/ubi8:8.4
ENV WA_BASE_UID=999
ENV WA_BASE_GID=0
ENV WA_USER=wauser
ENV WA_USER_HOME=/home/${WA_USER}
USER 0
RUN echo "Creating \"${WA_USER}\" user for Workload Automation and assign it to group \"${WA_BASE_GID}\"" \
&& userdel systemd-coredump \
&& if  [ ${WA_BASE_GID} -ne 0 ];then \
groupadd -g ${WA_BASE_GID} -r ${WA_USER};fi \
&& /usr/sbin/useradd -u ${WA_BASE_UID} -m -d ${WA_USER_HOME} -r -g ${WA_BASE_GID} ${WA_USER}
RUN mkdir -p /opt/wa_plugins /opt/wautils /tmp/custom_plugins
COPY plugins/* /opt/wa_plugins/
RUN chown -R ${WA_BASE_UID}:0 /opt/wa_plugins \
&& chmod -R 755 /opt/wa_plugins
COPY copy_custom_plugins.sh /opt/wautils/copy_custom_plugins.sh
RUN chmod 755 /opt/wautils/copy_custom_plugins.sh \
&& chown ${WA_BASE_UID}:${WA_BASE_GID} /opt/wautils/copy_custom_plugins.sh
USER ${WA_BASE_UID}
CMD [ "/opt/wautils/copy_custom_plugins.sh" ] 